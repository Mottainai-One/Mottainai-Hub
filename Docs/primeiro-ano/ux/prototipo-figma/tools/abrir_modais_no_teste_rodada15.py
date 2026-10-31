from pathlib import Path
tools=Path(__file__).resolve().parent
needle='await p.evaluate(id=>location.hash=id,id);'
extra=needle+"if(active){await p.locator('.modal-overlay').evaluateAll(es=>es.forEach(e=>e.classList.remove('aberto')));await m.evaluate(e=>e.classList.add('aberto'));}"
for filename in ['testar_rodada15.cjs','testar_detalhes_rodada15.cjs']:
    p=tools/filename;s=p.read_text(encoding='utf-8')
    if extra not in s:p.write_text(s.replace(needle,extra),encoding='utf-8')
