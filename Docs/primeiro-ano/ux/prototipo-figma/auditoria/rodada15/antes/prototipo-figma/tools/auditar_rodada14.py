"""Audita os contratos e o escopo desta rodada de front-end."""
from pathlib import Path
from collections import Counter
from PIL import Image,ImageChops
import hashlib,json,re,sys

root=Path(__file__).resolve().parents[2]
proto=root/'prototipo-figma'
out=proto/'auditoria/rodada14'
before=json.loads((out/'antes.json').read_text(encoding='utf-8'))
sha=lambda b:hashlib.sha256(b).hexdigest()
changed=[f for f,h in before.items() if sha((root/f).read_bytes())!=h]
assert not any(f.endswith('.java') for f in changed)
assert not any('application' in f or 'gradle' in f for f in changed)
assert not any(f.endswith('/home.jsp') or f.endswith('/home.css') for f in changed)
contracts=[]
for folder in ['src/main/webapp/WEB-INF/jsp','prototipo-figma/jsp']:
    for name in ['planos','sobre-nos']:
        f=f'{folder}/{name}.jsp'
        old=(out/'antes'/f).read_text(encoding='utf-8')
        new=(root/f).read_text(encoding='utf-8')
        for attr in ['action','method','name','value','id']:
            a=Counter(re.findall(r'\b'+attr+r'="([^"]*)"',old))
            b=Counter(re.findall(r'\b'+attr+r'="([^"]*)"',new))
            assert not a-b,(f,attr,a-b)
        assert set(re.findall(r'\$\{[^}]+\}',old))<=set(re.findall(r'\$\{[^}]+\}',new))
        assert Counter(re.findall(r'<(?:c|fmt):[^>]+>',old))==Counter(re.findall(r'<(?:c|fmt):[^>]+>',new))
        contracts.append(f)
# As duas alterações nos estilos administrativos/públicos são somente remoção das regras do badge.
for name in ['crud','publico']:
    f=f'prototipo-figma/css/{name}.css'
    old=(out/'antes'/f).read_text(encoding='utf-8')
    expected=re.sub(r'[^{}\n]*\.preview-notice[^{}]*\{[^{}]*\}\n?','',old)
    assert expected==(root/f).read_text(encoding='utf-8')
badges=[]
for base in [root/'src/main/webapp',proto/'jsp',proto/'html']:
    for f in base.rglob('*'):
        if f.suffix not in ['.html','.jsp']:continue
        s=f.read_text(encoding='utf-8')
        if re.search(r'<aside\b[^>]*(?:preview-note|preview-notice)',s):badges.append(str(f))
assert not badges
sys.path.insert(0,str(proto/'tools'))
from gerar_html import generate
for page in ['home','planos','sobre-nos','faq']:
    assert (proto/'html'/(page+'.html')).read_text(encoding='utf-8')==generate(page+'.jsp')
assert 'preview-note' not in (proto/'tools/gerar_html.py').read_text(encoding='utf-8')
for f in ['team-arrow-right.svg','planos-padrao-hero-azul.svg','home-monitor-predictive-alerts.png']:
    assert (proto/'assets/img'/f).read_bytes()==(root/'src/main/resources/static/assets/img'/f).read_bytes()
old=Image.open(proto/'auditoria/rodada11/monitor-after.png')
new=Image.open(proto/'assets/img/home-monitor-predictive-alerts.png')
assert old.size==new.size==(1872,1488)
bbox=ImageChops.difference(old,new).convert('RGB').getbbox()
assert bbox==(30,36,1821,1014),bbox
# Carcaça/base do monitor e demais imagens da Home permanecem fora da alteração.
for f in before:
    if '/assets/img/' in f and not f.endswith('home-monitor-predictive-alerts.png'):
        assert sha((root/f).read_bytes())==before[f],f
result=dict(passed=True,changedExistingFiles=changed,contractsPreserved=contracts,
            backendUnchanged=True,homeMarkupAndCssUnchanged=True,crudBehaviorUnchanged=True,
            visibleBadgesRemoved=True,htmlGeneratedFromJsp=True,monitorDifferenceBBox=bbox)
(out/'invariantes.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(result,ensure_ascii=False,indent=2))
