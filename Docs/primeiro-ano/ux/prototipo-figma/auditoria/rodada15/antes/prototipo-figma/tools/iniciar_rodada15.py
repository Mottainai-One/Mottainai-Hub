from pathlib import Path
import hashlib,json,shutil
root=Path(__file__).resolve().parents[2]
out=root/'prototipo-figma/auditoria/rodada15'
out.mkdir(parents=True,exist_ok=True)
if (out/'antes.json').exists(): raise SystemExit('Baseline já existe')
files=[p for base in ['src','prototipo-figma/jsp','prototipo-figma/html','prototipo-figma/css','prototipo-figma/js','prototipo-figma/assets','prototipo-figma/tools'] for p in (root/base).rglob('*') if p.is_file() and '__pycache__' not in str(p)]
hashes={str(p.relative_to(root)).replace('\\','/'):hashlib.sha256(p.read_bytes()).hexdigest() for p in files}
(out/'antes.json').write_text(json.dumps(hashes,indent=2),encoding='utf-8')
for p in files:
    if p.suffix in ['.jsp','.css','.js','.py']:
        target=out/'antes'/p.relative_to(root);target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,target)
(out/'video.html').write_text('<!doctype html><html><body style="margin:0"><video controls src="file:///C:/Users/20260215-ieg/Videos/Grava%C3%A7%C3%B5es%20de%20Tela/Grava%C3%A7%C3%A3o%20de%20Tela%202026-10-28%20074045.mp4"></video></body></html>',encoding='utf-8')
print(len(files),'arquivos registrados')
