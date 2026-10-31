"""Servidor de comparação isolado, GET apenas. Não modifica/configura o Spring nem persiste dados."""
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import unquote, urlsplit
import argparse
from gerar_html import generate

ROOT=Path(__file__).resolve().parents[1]


class Preview(SimpleHTTPRequestHandler):
    def do_GET(self):
        path=unquote(urlsplit(self.path).path)
        if path.startswith('/ver-jsp/'):
            name=Path(path).name
            if not name.endswith('.jsp') or not (ROOT/'jsp'/name).is_file():
                self.send_error(404);return
            # A mesma projeção demonstrativa que gerou o HTML; não é execução Spring/JSP real.
            body=generate(name,login='login=1' in self.path).encode('utf-8')
            self.send_response(200);self.send_header('Content-Type','text/html; charset=utf-8')
            self.send_header('Content-Length',str(len(body)));self.end_headers();self.wfile.write(body);return
        if path.startswith('/prototipo-figma/'):
            self.path=self.path.replace('/prototipo-figma/','/',1)
        super().do_GET()

    def do_POST(self):
        self.send_error(405,'Preview visual: autenticação e persistência indisponíveis')


if __name__=='__main__':
    cli=argparse.ArgumentParser();cli.add_argument('--port',type=int,default=8767);options=cli.parse_args()
    server=ThreadingHTTPServer(('127.0.0.1',options.port),partial(Preview,directory=str(ROOT)))
    print(f'Preview: http://127.0.0.1:{options.port}/index.html',flush=True)
    print('JSP de demonstração: /ver-jsp/companies.jsp — sem Spring/CRUD real. Ctrl+C encerra.',flush=True)
    try:server.serve_forever()
    except KeyboardInterrupt:pass
    finally:server.server_close()
