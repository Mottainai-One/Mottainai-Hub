"""Valida o preview GET isolado e a equivalência da projeção JSP com o HTML gerado."""
from functools import partial
from http.server import ThreadingHTTPServer
from threading import Thread
from urllib.request import urlopen, Request
from urllib.error import HTTPError
import json
from preview import Preview, ROOT

server=ThreadingHTTPServer(('127.0.0.1',0),partial(Preview,directory=str(ROOT)))
thread=Thread(target=server.serve_forever,daemon=True);thread.start()
base='http://127.0.0.1:'+str(server.server_port)
result={'pages':[],'postRejected':False}
try:
    assert urlopen(base+'/index.html').status==200
    for jsp in sorted((ROOT/'jsp').glob('*.jsp')):
        expected=(ROOT/'html'/(jsp.stem+'.html')).read_text(encoding='utf-8').encode('utf-8')
        actual=urlopen(base+'/ver-jsp/'+jsp.name).read()
        assert expected==actual,jsp.name
        assert urlopen(base+'/html/'+jsp.stem+'.html').status==200
        result['pages'].append({'page':jsp.stem,'projectionEqualsHtml':True})
    try:urlopen(Request(base+'/ver-jsp/home.jsp',data=b'preview',method='POST'))
    except HTTPError as error:
        assert error.code==405;result['postRejected']=True
    assert result['postRejected'];result['passed']=True
finally:
    server.shutdown();server.server_close()
    (ROOT/'auditoria/preview.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
print(json.dumps({'passed':result.get('passed',False),'pages':len(result['pages']),'postRejected':result['postRejected']}))
