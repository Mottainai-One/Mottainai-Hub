"""Confere alterações restritas às imagens dos dispositivos e ao encaixe do monitor."""
from pathlib import Path
import hashlib
import json
import sys
import re
from PIL import Image

root = Path(__file__).resolve().parents[2]
proto = root / 'prototipo-figma'
out = proto / 'auditoria/rodada11'
before = json.loads((out / 'antes.json').read_text(encoding='utf-8-sig'))
sha = lambda b: hashlib.sha256(b).hexdigest()
changed = [name for name, digest in before.items() if sha((root / name).read_bytes()) != digest]
expected = ['src/main/webapp/WEB-INF/jsp/home.jsp', 'prototipo-figma/jsp/home.jsp', 'prototipo-figma/html/home.html']
assert sorted(changed) == sorted(expected), changed
pairs = {'home-mobile-perfil.png':'home-mobile-profile-camila.png',
         'home-mobile-assistente.png':'home-mobile-lo-conversation.png',
         'home-painel-web.png':'home-monitor-predictive-alerts.png'}
for label, folder in [('ativo',root / 'src/main/webapp/WEB-INF/jsp'),('paralelo',proto / 'jsp')]:
    old = (out / (label + '-home.jsp')).read_bytes()
    for a,b in pairs.items():
        assert old.count(a.encode()) == 1
        old = old.replace(a.encode(),b.encode())
    old = old.replace(b'home-monitor-predictive-alerts.png\"', b'home-monitor-predictive-alerts.png\" width=\"624\"')
    if label == 'paralelo':
        old = re.sub(rb'^[ \t]*<span class="marca-monitor(?:-icone)?"[^\r\n]*\r?\n', b'', old, flags=re.M)
    assert old == (folder / 'home.jsp').read_bytes(), label
sys.path.insert(0,str(proto / 'tools'))
from gerar_html import generate
assert (proto / 'html/home.html').read_text(encoding='utf-8') == generate('home.jsp')
assets=[]
for name in pairs.values():
    f=proto / 'assets/img' / name
    assert f.read_bytes() == (root / 'src/main/resources/static/assets/img' / name).read_bytes()
    with Image.open(f) as im:
        assert im.mode == 'RGBA'
        assert im.getpixel((0,0))[3] == 0
        assets.append(dict(name=name,size=list(im.size),sha256=sha(f.read_bytes())))
figma_final={n['id']:n for n in json.loads((out / 'figma-final.json').read_text())}
figma_before={}
def visit(n):
    figma_before[n['id']]=n
    for child in n.get('children') or []:
        visit(child)
for node in json.loads((out / 'figma-before-devices.json').read_text()):
    visit(node)
for node_id in ['101:24122','101:25139','101:24142','101:25158','101:25119']:
    for key in ['w','h','x','y']:
        assert abs(figma_before[node_id][key]-figma_final[node_id][key]) < .001
    assert figma_before[node_id]['m'] == figma_final[node_id]['transform']
assert figma_final['101:24258']['children']==['101:25108','114:7745']
for side in ['left','right']:
    a=Image.open(out/(side+'-raw-0.png')).convert('RGB')
    b=Image.open(out/(side+'-source-updated.png')).convert('RGB')
    assert a.size==b.size
    # Notch, bordas e lateral física: pixels originais permanecem idênticos.
    for point in [(900,105),(1290,150),(20,1400),(900,1250),(1110,600),(400,1570)]:
        assert a.getpixel(point)==b.getpixel(point),(side,point)
result=dict(passed=True,changedExistingFiles=changed,unchangedFiles=len(before)-len(changed),
            onlyDeviceImageMarkupChanged=True,cssAndJavaScriptUnchanged=True,backendUnchanged=True,
            htmlGeneratedFromJsp=True,figmaDeviceTransformsPreserved=True,phoneShellSamplesUnchanged=True,assets=assets)
(out / 'invariantes.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(result,ensure_ascii=False,indent=2))
