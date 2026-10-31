"""Invariantes da V7 e dos contratos JSP. Execução somente de leitura, exceto os relatórios do protótipo."""
from pathlib import Path
from collections import Counter
from html.parser import HTMLParser
import hashlib
import json
import re
from urllib.parse import unquote, urlsplit

ROOT=Path(__file__).resolve().parents[1]
APP=ROOT.parent


def normalize(text):
    return text.replace('/prototipo-figma/css/','/assets/css/').replace('/prototipo-figma/js/','/assets/js/').replace('/prototipo-figma/assets/','/assets/')


def elements(text):
    # As expressões internas são mantidas como texto, inclusive c:out dentro de atributos.
    return dict(el=Counter(x for x in re.findall(r'\$\{([^}]+)\}',text) if x!='pageContext.request.contextPath'),
                jstl=Counter(re.findall(r'</?(?:c|fmt):[A-Za-z]+',text)),
                names=Counter(re.findall(r'\bname="([^"]+)"',text)),
                actions=Counter(re.findall(r'<form\b[^>]*\baction="([^"]+)"',text,re.S)),
                methods=Counter(re.findall(r'\bmethod="([^"]+)"',text)),
                hidden=Counter(re.findall(r'<input\b[^>]*type="hidden"[^>]*>',text,re.S)),
                ids=Counter(re.findall(r'\bid="([^"]+)"',text)))


class Links(HTMLParser):
    def __init__(self): super().__init__(); self.links=[]
    def handle_starttag(self,tag,attributes):
        at=dict(attributes)
        for name in ('src','href'):
            if name in at:self.links.append(at[name])


def main():
    results={'activeFiles':{},'contracts':{},'resources':{},'login':{},'javascript':{}}
    failures=[]
    baseline=ROOT/'auditoria/rodada5/base-ativa.json'
    if not baseline.exists():baseline=ROOT/'auditoria/rodada4/base-ativa.json'
    if not baseline.exists():baseline=ROOT/'auditoria/rodada3/base-ativa.json'
    if not baseline.exists():baseline=ROOT/'auditoria/rodada2/base-ativa.json'
    if not baseline.exists():baseline=ROOT/'auditoria/base-v7-sha256.json'
    base=json.loads(baseline.read_text())
    results['comparisonBaseline']=str(baseline.relative_to(ROOT))
    ide_changes=[]
    for rel,digest in base.items():
        path=APP/rel
        if not path.is_file() or hashlib.sha256(path.read_bytes()).hexdigest()!=digest:
            if rel.replace('\\','/')=='.idea/workspace.xml':ide_changes.append(rel)
            else:failures.append('V7 alterada: '+rel)
    results['activeFiles']={'checked':len(base),'applicationChanges':len(failures),'ideWorkspaceChanges':ide_changes}
    admin=['addresses','companies','employee-roles','employees','home-crud-page','stores','subscription-plans','user-accounts']
    for name in admin:
        old=(APP/'src/main/webapp/WEB-INF/jsp'/(name+'.jsp')).read_text(encoding='utf-8')
        new=normalize((ROOT/'jsp'/(name+'.jsp')).read_text(encoding='utf-8'))
        before,after=elements(old),elements(new)
        passed={key:before[key]==after[key] for key in before}
        # Todo o body administrativo continua idêntico, salvo os caminhos dos recursos.
        passed['body']=old[old.index('<body'):]==new[new.index('<body'):]
        results['contracts'][name]={'passed':passed,'forms':sum(before['actions'].values()),
            'inputNames':dict(before['names']),'actions':dict(before['actions']),
            'methods':dict(before['methods']),'hiddenInputs':sum(before['hidden'].values()),
            'jstlTags':sum(before['jstl'].values()),'elExpressions':sum(before['el'].values())}
        if not all(passed.values()):failures.append('Contrato JSP: '+name)
    old=(APP/'src/main/webapp/WEB-INF/jsp/home.jsp').read_text(encoding='utf-8')
    new=normalize((ROOT/'jsp/home.jsp').read_text(encoding='utf-8'))
    start='    <!-- ===== MODAL DE LOG-IN ===== -->'
    results['login']['markupIdentical']=old[old.index(start):]==new[new.index(start):]
    for kind in ['css','js']:
        source=APP/'src/main/resources/static/assets'/kind/('modais.'+kind)
        results['login'][kind+'Identical']=source.read_bytes()==(ROOT/kind/('modais.'+kind)).read_bytes()
    if not all(results['login'].values()):failures.append('Modais aprovados foram alterados')
    results['publicContracts']={}
    for name in ['home','sobre-nos','planos']:
        old=(APP/'src/main/webapp/WEB-INF/jsp'/(name+'.jsp')).read_text(encoding='utf-8')
        new=normalize((ROOT/'jsp'/(name+'.jsp')).read_text(encoding='utf-8'))
        before,after=elements(old),elements(new)
        passed={key:before[key]==after[key] for key in ['el','names','actions','methods','hidden']}
        results['publicContracts'][name]=passed
        if not all(passed.values()):failures.append('Contrato público JSP: '+name)
    results['contact']={}
    for name in ['home','sobre-nos','planos']:
        old=(APP/'src/main/webapp/WEB-INF/jsp'/(name+'.jsp')).read_text(encoding='utf-8')
        new=(ROOT/'jsp'/(name+'.jsp')).read_text(encoding='utf-8')
        pattern=r'<a\b[^>]*href="([^"]*)"[^>]*>\s*Entre em contato\s*</a>'
        preserved=Counter(re.findall(pattern,old,re.I))==Counter(re.findall(pattern,new,re.I))
        results['contact'][name]=preserved
        if not preserved:failures.append('Destino de contato alterado: '+name)
    broken=[]
    for file in sorted((ROOT/'html').glob('*.html')):
        content=file.read_text(encoding='utf-8'); parser=Links();parser.feed(content)
        if '${' in content or '<c:' in content or '<%@' in content:failures.append('JSP residual no HTML: '+file.name)
        forms=re.findall(r'<form\b[^>]*>',content)
        if any('method="dialog"' not in tag or ' action=' in tag for tag in forms):failures.append('Form HTML não neutralizado: '+file.name)
        for link in parser.links:
            url=urlsplit(link)
            if url.scheme or url.netloc or not url.path:continue
            target=(file.parent/unquote(url.path)).resolve()
            if not target.is_relative_to(ROOT) or not target.is_file():broken.append({'page':file.name,'link':link})
        results['javascript'][file.stem]=re.findall(r'<script\s+src="([^"]+)"',content)
    for file in (ROOT/'css').glob('*.css'):
        content=file.read_text(encoding='utf-8')
        for match in re.finditer(r'url\(\s*["\x27]?([^"\x27)]+)',content):
            link=match.group(1)
            if urlsplit(link).scheme or link.startswith('data:'):continue
            if not (file.parent/unquote(link)).resolve().is_file():broken.append({'page':file.name,'link':link})
    results['resources']={'broken':broken,'htmlCount':len(list((ROOT/'html').glob('*.html'))),'jspCount':len(list((ROOT/'jsp').glob('*.jsp')))}
    if broken:failures.append('Referências quebradas')
    if results['resources']['htmlCount']!=12 or results['resources']['jspCount']!=12:failures.append('Faltam páginas')
    results['contractsPassed']=all(all(item['passed'].values()) for item in results['contracts'].values())
    results['baselineIdentical']=not ide_changes and results['activeFiles']['applicationChanges']==0
    results['failures']=failures;results['passed']=not failures
    (ROOT/'auditoria/invariantes.json').write_text(json.dumps(results,ensure_ascii=False,indent=2),encoding='utf-8')
    print(json.dumps({'passed':not failures,'activeFiles':len(base),'pages':12,'failures':failures,'broken':broken},ensure_ascii=False))
    if failures:raise SystemExit(1)


if __name__=='__main__':main()
