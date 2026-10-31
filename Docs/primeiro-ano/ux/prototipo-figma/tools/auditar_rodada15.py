from pathlib import Path
from collections import Counter
import hashlib,json,re,importlib.util
root=Path(__file__).resolve().parents[2];out=root/'prototipo-figma/auditoria/rodada15'
before=json.loads((out/'antes.json').read_text(encoding='utf-8'))
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
changed=[f for f,h in before.items() if not (root/f).exists() or sha(root/f)!=h]
assert not any(f.startswith('src/main/java/') or f.startswith('src/test/') or f.endswith(('.properties','.yml')) for f in changed)
contracts=[]
for f in changed:
    if not f.endswith('.jsp'):continue
    old=out/'antes'/f
    if not old.exists():continue
    a=old.read_text(encoding='utf-8');b=(root/f).read_text(encoding='utf-8')
    for key in ['action','method','name','id']:
        original=Counter(re.findall(r'\b'+key+r'="([^"]*)"',a));current=Counter(re.findall(r'\b'+key+r'="([^"]*)"',b))
        assert not original-current,(f,key,original-current)
    # O ID da sessão deixou de ser exibido no novo popup; nenhum binding de formulário muda.
    expressions=set(re.findall(r'\$\{[^}]+\}',a))-{'${sessionScope.administrationId}'}
    assert expressions<=set(re.findall(r'\$\{[^}]+\}',b)),f
    old_logic=re.findall(r'<c:(?:if|when|otherwise|choose|forEach|url|param)\b[^>]*>',a)
    new_logic=re.findall(r'<c:(?:if|when|otherwise|choose|forEach|url|param)\b[^>]*>',b)
    assert old_logic==new_logic,f
    # Inputs/valores/hiddens do backend não fazem parte do ajuste visual.
    assert re.findall(r'<(?:input|select|textarea)\b[^>]*>',a)==re.findall(r'<(?:input|select|textarea)\b[^>]*>',b),f
    contracts.append(f)
for base in ['src/main/resources/static/assets','prototipo-figma/assets']:
    p=root/base/'img/wordmark-mottainai.svg'
    assert p.read_bytes()==Path('C:/Users/20260215-ieg/Downloads/Group 147.svg').read_bytes()
for f,h in before.items():
    if '/assets/' in f and Path(f).suffix in ['.png','.jpg','.jpeg','.svg','.webp']:assert sha(root/f)==h,f
for p in (root/'prototipo-figma/html').glob('*.html'):
    s=p.read_text(encoding='utf-8');assert not re.search(r'<aside[^>]*preview-notice|id="preview-note"|class="nota-demonstracao"',s)
spec=importlib.util.spec_from_file_location('g',root/'prototipo-figma/tools/gerar_html.py');g=importlib.util.module_from_spec(spec);spec.loader.exec_module(g)
for p in (root/'prototipo-figma/jsp').glob('*.jsp'):
    assert g.generate(p.name)==(root/'prototipo-figma/html'/(p.stem+'.html')).read_text(encoding='utf-8'),p.name
created=[]
for base in ['src','prototipo-figma/jsp','prototipo-figma/html','prototipo-figma/css','prototipo-figma/js','prototipo-figma/assets','prototipo-figma/tools']:
    for p in (root/base).rglob('*'):
        if p.is_file() and '__pycache__' not in str(p) and p.relative_to(root).as_posix() not in before:created.append(p.relative_to(root).as_posix())
result=dict(passed=True,backendUnchanged=True,existingImagesUnchanged=True,wordmarkIdenticalToAttachment=True,contractsPreserved=contracts,changedExistingFiles=changed,createdFiles=created)
(out/'invariantes.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps({'passed':True,'changed':len(changed),'created':len(created),'jspContracts':len(contracts)}))
