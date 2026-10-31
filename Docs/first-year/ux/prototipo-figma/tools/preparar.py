"""Adapta somente cópias do protótipo; nunca grava na aplicação ativa."""
from pathlib import Path
import json
import re
import shutil

ROOT = Path(__file__).resolve().parents[1]
APP = ROOT.parent


def main():
    if (ROOT / "auditoria/preparado.json").exists():
        print("Preparação inicial já concluída; use gerar_html.py para atualizar os HTMLs.")
        return
    # Fontes locais evitam que o preview dependa de rede ou altere dependências.
    fonts = json.loads((ROOT / 'auditoria/font-downloads.json').read_text())
    css = (ROOT / 'referencias/fontes-google.css').read_text()
    for font in fonts:
        css = css.replace(font['url'], '../assets/fonts/' + font['file'])
    (ROOT / 'css/fontes.css').write_text(css, encoding='utf-8')

    for source in (APP / 'src/main/resources/static/assets').rglob('*'):
        if source.is_file() and source.parent.name in ('img', 'icons'):
            texts = '\n'.join(p.read_text(encoding='utf-8') for p in list((ROOT / 'jsp').glob('*.jsp')) + list((ROOT / 'css').glob('*.css')))
            if source.name in texts:
                shutil.copy2(source, ROOT / 'assets' / source.parent.name / source.name)

    for name in ('home', 'sobre-nos', 'planos', 'crud'):
        p = ROOT / 'css' / (name + '.css')
        p.write_text(re.sub(r'(?m)^\s*@import[^\n]*\n', '', p.read_text(encoding='utf-8')), encoding='utf-8')

    for p in (ROOT / 'jsp').glob('*.jsp'):
        text = p.read_text(encoding='utf-8')
        extra = '<link rel="stylesheet" href="${pageContext.request.contextPath}/prototipo-figma/css/fontes.css">\n'
        if p.stem in ('home', 'sobre-nos', 'planos'):
            extra += '<link rel="stylesheet" href="${pageContext.request.contextPath}/prototipo-figma/css/publico.css">\n'
        text = text.replace('</head>', extra + '</head>')
        if p.stem == 'home':
            # O mascote adicional da V7 não aparece nesse frame; os modais aprovados não são tocados.
            text = re.sub(r'\s*<img\s+src="[^"\n]*mascote-lontra.png"[\s\S]*?class="mascote-cta"\s*/>', '', text)
        if p.stem == 'sobre-nos':
            text = text.replace('/assets/img/group-132.png', '/assets/img/home-logo.png', 1)
            start = text.index('<footer>')
            text = text[:start] + text[start:].replace('/assets/img/group-132.png', '/assets/img/home-logo-rodape.png')
        if p.stem == 'home-crud-page':
            text = text.replace('/assets/img/casa.svg', '/assets/icons/home.svg')
        p.write_text(text, encoding='utf-8')

    home = (ROOT / 'jsp/home.jsp').read_text(encoding='utf-8')
    footer = home[home.index('<footer>'):home.index('</footer>') + len('</footer>')]
    p = ROOT / 'jsp/planos.jsp'
    text = p.read_text(encoding='utf-8').replace('/assets/img/logo.svg', '/assets/img/home-logo.png')
    text = text.replace('/assets/img/blue-lines.svg', '/assets/img/planos-padrao-hero.png')
    text = text.replace('/assets/img/story-set-plans.svg', '/assets/img/planos-duvidas.png')
    text = re.sub(r'\s*<div id="right">[\s\S]*?</div>', '', text, count=1)
    old = text[text.index('        <div id="toggle-plano">'):text.index('        <div class="container">')]
    toggle = '''        <fieldset id="toggle-plano">
          <legend class="sr-only">Periodicidade de cobrança dos planos</legend>
          <input type="radio" name="periodicidade" id="cobranca-mensal" value="mensal" checked>
          <label class="opcao" for="cobranca-mensal">Mensal</label>
          <input type="radio" name="periodicidade" id="cobranca-anual" value="anual">
          <label class="opcao" for="cobranca-anual">Anual</label>
        </fieldset>

'''
    text = text.replace(old, toggle)
    for monthly, annual in [('1.200', '10.000'), ('3.500', '28.000')]:
        text = text.replace('<strong>R$ ' + monthly + '</strong>', '<strong class="valor-mensal">R$ ' + monthly + '</strong><strong class="valor-anual">R$ ' + annual + '</strong>')
    text = text.replace('<span>/mês</span>', '<span class="periodo-mensal">/mês</span><span class="periodo-anual">/ano</span>')
    text = text.replace('href="#saiba-mais"', 'href="faq.jsp"')
    text = re.sub(r'\s*<script src="[^"\n]*planos.js"></script>', '', text)
    text = text.replace('</body>', footer + '\n</body>')
    p.write_text(text, encoding='utf-8')
    (ROOT / 'js/planos.js').write_text('// Protótipo: periodicidade e preços usam radios nativos e CSS. Nenhum script é carregado nesta página.\n', encoding='utf-8')

    # FAQ deriva do scaffold real de Planos; conteúdo exclusivamente ilustrativo.
    faq = text[:text.index('<main>')] + '''<main class="faq-main">
      <section class="faq-hero">
        <p class="eyebrow">Bom demais para ser desperdiçado</p>
        <h1>Como podemos <em>ajudar?</em></h1>
        <p>Entenda a proposta da Mottainai e encontre respostas para começar.</p>
        <p class="nota-demonstracao">Proposta visual. Perguntas e respostas demonstrativas, sujeitas à validação da equipe.</p>
      </section>
      <section class="faq-lista" aria-label="Perguntas frequentes">
'''
    questions = [
        ('O que é a Mottainai?', 'Uma proposta de plataforma para acompanhar estoques e apoiar a redução de desperdícios no varejo alimentar.'),
        ('Para quais tipos de mercado a plataforma foi criada?', 'Esta demonstração considera mercados e redes de varejo. A adequação à operação deve ser avaliada com a equipe.'),
        ('Como funciona o controle de validade?', 'O protótipo ilustra o acompanhamento de produtos e vencimentos. A forma de cadastro e as integrações serão confirmadas na implantação.'),
        ('Como funcionam os alertas?', 'A proposta visual apresenta alertas para apoiar a priorização de ações. Canais, limites e regras dependem de definição do produto.'),
        ('Quantas lojas posso cadastrar?', 'Os limites devem ser confirmados no plano contratado; este conteúdo não estabelece condições comerciais.'),
        ('Qual plano devo escolher?', 'Compare as opções na página de Planos e avalie as necessidades da sua operação com a equipe.'),
        ('Posso alterar meu plano?', 'As condições de mudança de plano devem ser combinadas com a equipe. Esta demonstração não executa alterações de assinatura.'),
        ('Como funciona o cadastro de funcionários?', 'A área administrativa apresenta o vínculo entre lojas, funcionários e cargos. Os cadastros desta prévia são apenas exemplos visuais.'),
        ('Os dados são protegidos?', 'O projeto atual possui mecanismos de proteção de dados. Esta FAQ demonstrativa não substitui documentação técnica, política de privacidade ou garantias contratuais.'),
        ('Como entrar em contato?', 'O destino definitivo dos botões Entre em contato ainda será informado. Os links existentes foram mantidos sem criar uma integração nova.'),
    ]
    for question, answer in questions:
        faq += '<details><summary>' + question + '</summary><p>' + answer + '</p></details>\n'
    faq += '''</section><section class="faq-rodape"><h2>Conheça os nossos planos</h2><p>Opções para diferentes momentos da sua operação.</p><a class="btn-contato" href="${pageContext.request.contextPath}/planos">Ver planos</a></section></main>'''
    faq += footer + '\n</body></html>'
    faq = faq.replace('Mottainai | Planos', 'Mottainai | Perguntas frequentes').replace('/css/planos.css', '/css/faq.css')
    (ROOT / 'jsp/faq.jsp').write_text(faq, encoding='utf-8')


if __name__ == '__main__':
    main()
