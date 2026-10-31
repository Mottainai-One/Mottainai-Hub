"""Auditoria local da alteraÃ§Ã£o exclusiva das linhas decorativas."""
from pathlib import Path
import hashlib
import json
import re
import sys
import xml.etree.ElementTree as ET

root = Path(__file__).resolve().parents[2]
proto = root / 'prototipo-figma'
evidence = proto / 'auditoria/rodada10'
before = json.loads((evidence / 'antes.json').read_text(encoding='utf-8-sig'))
sha = lambda b: hashlib.sha256(b).hexdigest()
changed = [p for p, digest in before.items() if sha((root / p).read_bytes()) != digest]
expected = [f'{folder}/{name}.{ext}' for folder, ext in [
    ('src/main/webapp/WEB-INF/jsp', 'jsp'), ('prototipo-figma/jsp', 'jsp'),
    ('src/main/resources/static/assets/css', 'css'), ('prototipo-figma/css', 'css'),
    ('prototipo-figma/html', 'html')
] for name in ['home', 'sobre-nos']]
assert sorted(changed) == sorted(expected), changed

def normalize(s, name):
    if name == 'home':
        s = re.sub(r'<img\b(?=[^>]*\bid="(?:ecossistema-linha|cta-final-linha)")[^>]*>', '', s)
    else:
        s = re.sub(r'<div class="about-blue-lines"[^>]*>.*?</div>', '', s, flags=re.S)
        s = s.replace('<section class="equipe-com-linhas">', '<section>')
    return re.sub(r'\s+', ' ', s).strip()

for kind, folder in [('ativo', root / 'src/main/webapp/WEB-INF/jsp'), ('paralelo', proto / 'jsp')]:
    for name in ['home', 'sobre-nos']:
        old = (evidence / kind / (name + '.jsp')).read_text(encoding='utf-8-sig')
        new = (folder / (name + '.jsp')).read_text(encoding='utf-8-sig')
        assert normalize(old, name) == normalize(new, name), (kind, name, 'conteÃºdo alterado')

for folder in ['src/main/resources/static/assets/css', 'prototipo-figma/css']:
    for name in ['home', 'sobre-nos']:
        rel = f'{folder}/{name}.css'
        content = (root / rel).read_bytes()
        prefix = content.split(b'/* Rodada 10')[0]
        prefix = prefix[:-2] if prefix.endswith(b'\r\n') else prefix[:-1]
        assert sha(prefix) == before[rel], (rel, 'CSS anterior alterado')

assets = []
for name, copied, original in [
    ('home-blue-lines-upper.svg', '104:27398', '101:24179'),
    ('home-blue-lines-lower.svg', '104:27472', '101:24143'),
    ('about-blue-lines-upper.svg', '104:27507', '91:9018'),
    ('about-blue-lines-lower.svg', '104:27544', '91:8981')
]:
    data = (proto / 'assets/img' / name).read_bytes()
    assert data == (root / 'src/main/resources/static/assets/img' / name).read_bytes()
    svg = ET.fromstring(data)
    assert b'<rect' not in data, name
    assets.append(dict(file=name, copiedNode=copied, originalNode=original,
                       width=svg.get('width'), height=svg.get('height'), sha256=sha(data)))
assert len({a['sha256'] for a in assets}) == 4
sys.path.insert(0, str(proto / 'tools'))
from gerar_html import generate
for name in ['home', 'sobre-nos']:
    assert (proto / 'html' / (name + '.html')).read_text(encoding='utf-8') == generate(name + '.jsp')
result = dict(passed=True, changedExistingFiles=changed, unchangedFiles=len(before)-len(changed),
              jspContentAndContractsPreserved=True, previousCssPreserved=True,
              htmlGeneratedFromJsp=True, assets=assets)
(evidence / 'invariantes.json').write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding='utf-8')
print(json.dumps(result, ensure_ascii=False, indent=2))
