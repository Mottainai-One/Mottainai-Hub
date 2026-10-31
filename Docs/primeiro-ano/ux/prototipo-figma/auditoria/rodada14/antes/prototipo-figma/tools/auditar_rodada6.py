"""Auditoria da rodada autorizada: contratos preexistentes preservados e backend restrito a Administration."""
from pathlib import Path
from collections import Counter
from html.parser import HTMLParser
from urllib.parse import urlsplit, unquote
import hashlib, json, re
from auditar import elements, normalize
from gerar_html import generate
ROOT=Path(__file__).resolve().parents[1];APP=ROOT.parent;OUT=ROOT/'auditoria/rodada6'
before=json.loads((OUT/'antes.json').read_text(encoding='utf-8'))
allowed={f'src/main/java/com/mottainai/crudinicial/{file}' for file in ['dao/AdministrationDao.java','dto/AdministrationRequestDTO.java','service/AdministrationService.java','controller/AdministrationController.java','controller/AdministrationViewController.java']}
changed=[];unchanged=0
for rel,digest in before.items():
    file=APP/rel
    assert file.is_file(),rel+' removido'
    if hashlib.sha256(file.read_bytes()).hexdigest()!=digest:
        changed.append(rel)
        if rel.startswith('src/'):assert rel in allowed,'Fonte ativa fora do escopo: '+rel
        if rel.startswith('prototipo-figma/'):
            assert not any('/'+name+'.' in rel for name in ['sobre-nos','planos','faq']),rel+' fora de escopo'
    else:unchanged+=1
assert set(rel for rel in changed if rel.startswith('src/'))==allowed
new_active=[str(p.relative_to(APP)).replace('\\','/') for p in (APP/'src').rglob('*') if p.is_file() and str(p.relative_to(APP)).replace('\\','/') not in before]
assert set(new_active)=={'src/main/webapp/WEB-INF/jsp/administrations.jsp','src/main/resources/static/assets/css/crud-ux.css','src/main/resources/static/assets/js/crud-ux.js','src/test/java/com/mottainai/crudinicial/service/AdministrationServiceTest.java','src/test/java/com/mottainai/crudinicial/controller/AdministrationManagementTest.java'},new_active
# A base ativa anterior também inclui Gradle, propriedades e demais arquivos fora de src.
fullbase=json.loads((ROOT/'auditoria/rodada5/base-ativa.json').read_text(encoding='utf-8'))
external=[]
for rel,digest in fullbase.items():
    file=APP/rel
    if file.is_file() and hashlib.sha256(file.read_bytes()).hexdigest()!=digest:
        if rel.replace('\\','/')=='.idea/workspace.xml':external.append(rel)
        else:assert rel.replace('\\','/') in allowed,'Arquivo fora da autorização: '+rel
contracts={}
for name in ['home','home-crud-page','companies','stores','employees','employee-roles','user-accounts','subscription-plans','addresses']:
    old=(APP/'src/main/webapp/WEB-INF/jsp'/f'{name}.jsp').read_text(encoding='utf-8')
    new=normalize((ROOT/'jsp'/f'{name}.jsp').read_text(encoding='utf-8'))
    old_elements,new_elements=elements(old),elements(new)
    # Novos atributos do perfil são permitidos; nenhum contrato preexistente pode desaparecer.
    check={key:not bool(old_elements[key]-new_elements[key]) for key in old_elements}
    assert all(check.values()),(name,check)
    contracts[name]=check
    oldforms=re.findall(r'<form\b[^>]*>',old)
    for form in oldforms:assert form in new,(name,form)
# Nenhum submit ou hash foi introduzido na projeção HTML.
class Links(HTMLParser):
    def __init__(self):super().__init__();self.values=[]
    def handle_starttag(self,tag,attributes):
        at=dict(attributes)
        for key in ['href','src']:
            if key in at:self.values.append(at[key])
resources=[];equivalence=[]
for page in sorted((ROOT/'jsp').glob('*.jsp')):
    html=ROOT/'html'/f'{page.stem}.html';content=html.read_text(encoding='utf-8')
    assert content==generate(page.name),page.name
    assert '${' not in content and '<c:' not in content,page.name
    assert all('method="dialog"' in tag and ' action=' not in tag for tag in re.findall(r'<form\b[^>]*>',content))
    parser=Links();parser.feed(content)
    for link in parser.values:
        url=urlsplit(link)
        if url.scheme or not url.path:continue
        path=(html.parent/unquote(url.path)).resolve()
        assert path.is_relative_to(ROOT) and path.is_file(),(page.name,link)
    equivalence.append({'page':page.stem,'html':True,'jsp':True,'equivalentProjection':True})
for file in (ROOT/'css').glob('*.css'):
    for value in re.findall(r'url\([\"\']?([^\)\"\']+)',file.read_text(encoding='utf-8')):
        if value.startswith(('http','data:')):continue
        assert (file.parent/value).is_file(),(file.name,value)
for folder,name in [('css','crud-ux.css'),('js','crud-ux.js')]:
    assert (ROOT/folder/name).read_bytes()==(APP/'src/main/resources/static/assets'/folder/name).read_bytes()
active=(APP/'src/main/webapp/WEB-INF/jsp/administrations.jsp').read_text(encoding='utf-8')
proto=normalize((ROOT/'jsp/administrations.jsp').read_text(encoding='utf-8')).replace('<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fontes.css">','')
assert active==proto,'Nova view ativa diverge do protótipo'
assert 'PasswordHash' not in active and 'passwordHash' not in active
assert not re.search(r'(?:acao=excluir|/delete|btn-perigo)',active)
for file in allowed:
    content=(APP/file).read_text(encoding='utf-8')
    if file.endswith(('AdministrationDao.java','AdministrationService.java','AdministrationController.java','AdministrationViewController.java')):
        assert not re.search(r'(?:DeleteMapping|deleteById|deleteAll|void delete)',content),file
report={'passed':True,'baselineChecked':len(before),'unchanged':unchanged,'changed':changed,'newActive':new_active,'contracts':contracts,'equivalence':equivalence,'otherBackendsUnchanged':True,'existingActiveFrontendUnchanged':True,'noDeletion':True,'prototypeOnlyExceptAdministration':True,'fullActiveBaselineChecked':len(fullbase),'ideMetadataChanges':external}
(OUT/'invariantes.json').write_text(json.dumps(report,indent=2,ensure_ascii=False),encoding='utf-8')
print(json.dumps({'passed':True,'checked':len(before),'changed':len(changed),'contracts':len(contracts),'equivalent':len(equivalence),'newActive':len(new_active)}))
