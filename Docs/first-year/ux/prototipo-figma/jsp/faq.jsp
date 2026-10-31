<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="pt-BR">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Mottainai | Perguntas frequentes</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/prototipo-figma/css/faq.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/prototipo-figma/css/fontes.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/prototipo-figma/css/publico.css">
<link rel="shortcut icon" href="${pageContext.request.contextPath}/prototipo-figma/assets/img/favicon.ico" type="image/x-icon">
<link rel="stylesheet" href="${pageContext.request.contextPath}/prototipo-figma/css/footer.css">
</head>
  <body class="pagina-faq">
    <header>
      <a href="${pageContext.request.contextPath}/home" class="logo">
        <img src="${pageContext.request.contextPath}/prototipo-figma/assets/img/mottainai-logo-completo.svg" alt="Mottainai" />
      </a>

      <nav>
        <ul>
          <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
          <li><a href="${pageContext.request.contextPath}/sobre-nos">Sobre nós</a></li>
          <li><a href="${pageContext.request.contextPath}/planos">Planos</a></li>
        </ul>
      </nav>

      <a href="https://mail.google.com/mail/?view=cm&amp;fs=1&amp;to=mottainai.contato@gmail.com" class="btn-contato botao-com-hover" target="_blank" rel="noopener noreferrer">Entre em contato</a>
    </header>
    <main class="faq-main">
      <div class="faq-decoracoes" aria-hidden="true"><img class="faq-linhas-esquerda" src="${pageContext.request.contextPath}/prototipo-figma/assets/img/faq-linhas-esquerda.svg" alt=""><img class="faq-linhas-direita" src="${pageContext.request.contextPath}/prototipo-figma/assets/img/faq-linhas-direita.svg" alt=""></div>
      <section class="faq-hero" aria-labelledby="faq-titulo">
        <p class="eyebrow">Bom demais para ser desperdiçado</p>
        <h1 id="faq-titulo">Como podemos <em>ajudar?</em></h1>
      </section>
      <section class="faq-lista" aria-label="Perguntas frequentes">
        <details><summary>O que é a Mottainai?</summary><p>Uma proposta de plataforma para acompanhar estoques e apoiar a redução de desperdícios no varejo alimentar.</p></details>
        <details><summary>Para quais tipos de mercado a plataforma foi criada?</summary><p>A plataforma considera mercados e redes de varejo. A adequação à operação deve ser avaliada com a equipe.</p></details>
        <details><summary>Como funciona o controle de validade?</summary><p>A plataforma permite o acompanhamento de produtos e vencimentos. A forma de cadastro e as integrações serão confirmadas na implantação.</p></details>
        <details><summary>Como funcionam os alertas?</summary><p>A plataforma apresenta alertas para apoiar a priorização de ações. Canais, limites e regras dependem de definição do produto.</p></details>
        <details><summary>Quantas lojas posso cadastrar?</summary><p>Os limites devem ser confirmados no plano contratado; este conteúdo não estabelece condições comerciais.</p></details>
      </section>
      <section class="faq-avaliacoes" aria-labelledby="avaliacoes-titulo">
        <h2 id="avaliacoes-titulo">Avaliações dos usuários</h2>
        <p class="faq-avaliacoes-subtitulo">Veja o que nossos usuários estão dizendo sobre o app</p>
        <div class="faq-carrossel" tabindex="0" role="region" aria-label="Avaliações dos usuários, deslize para navegar">
        <article class="faq-avaliacao">
          <div class="faq-avaliacao-topo"><span class="faq-avatar faq-avatar-0" aria-hidden="true">LM</span>
            <div class="faq-avaliacao-identidade"><h3>Lucas Martins</h3><div class="faq-nota"><span class="faq-estrelas" aria-label="5 estrelas">★★★★★</span><span>4,8</span></div></div>
          </div>
          <p>“Gostei bastante da experiência. O visual é bonito, limpo e fácil de usar no dia a dia.”</p>
        </article>
        <article class="faq-avaliacao">
          <div class="faq-avaliacao-topo"><span class="faq-avatar faq-avatar-1" aria-hidden="true">FR</span>
            <div class="faq-avaliacao-identidade"><h3>Fernanda Rocha</h3><div class="faq-nota"><span class="faq-estrelas" aria-label="5 estrelas">★★★★★</span><span>5,0</span></div></div>
          </div>
          <p>“Aplicativo muito intuitivo e organizado. Consegui encontrar tudo com rapidez e sem dificuldade.”</p>
        </article>
        <article class="faq-avaliacao">
          <div class="faq-avaliacao-topo"><span class="faq-avatar faq-avatar-2" aria-hidden="true">BS</span>
            <div class="faq-avaliacao-identidade"><h3>Beatriz Souza</h3><div class="faq-nota"><span class="faq-estrelas" aria-label="5 estrelas">★★★★★</span><span>4,7</span></div></div>
          </div>
          <p>“O app é prático e funcional. A navegação é simples e a proposta é muito boa.”</p>
        </article>
        </div>
      </section>
    </main><footer>
    <div class="footer-topo">
        <div class="footer-logo">
            <img class="footer-wordmark" src="${pageContext.request.contextPath}/prototipo-figma/assets/img/mottainai-wordmark-rodape.svg" alt="Mottainai" />
            <p>Bom demais para ser desperdiçado,</p>
        </div>

        <div class="footer-coluna">
            <h5>Página inicial</h5>
            <ul>
                <li><a href="${pageContext.request.contextPath}/home#diferencial">Diferencial</a></li>
                <li><a href="${pageContext.request.contextPath}/home#funcionalidades">Funcionalidades</a></li>
                <li><a href="${pageContext.request.contextPath}/home#sistema">Sistema</a></li>
            </ul>
        </div>

        <div class="footer-coluna">
            <h5>Sobre nós</h5>
            <ul>
                <li><a href="${pageContext.request.contextPath}/sobre-nos#nossa-equipe">Nossa equipe</a></li>
                <li><a href="${pageContext.request.contextPath}/sobre-nos#proposta">Nosso propósito</a></li>
                <li><a href="${pageContext.request.contextPath}/sobre-nos#nosso-ideal">No que acreditamos</a></li>
            </ul>
        </div>

        <div class="footer-coluna">
            <h5>Planos</h5>
            <ul>
                <li><a href="${pageContext.request.contextPath}/planos#escolha-plano">Condições</a></li>
                <li><a href="${pageContext.request.contextPath}/planos">Termos de Uso</a></li>
                <li><a href="${pageContext.request.contextPath}/planos#duvidas">Contato</a></li>
            </ul>
        </div>

        <div class="footer-coluna">
            <h5>Nos siga nas Redes!</h5>
            <ul>
                <li><a href="https://www.instagram.com/mottainai.estoques/" target="_blank" rel="noopener noreferrer">Instagram: @mottainai.estoques</a></li>
                <li><a href="https://wa.me/5511993332592" target="_blank" rel="noopener noreferrer">Tel Empresarial: (+55) 11 99333-2592</a></li>
                <li><a href="https://mail.google.com/mail/?view=cm&amp;fs=1&amp;to=mottainai.contato@gmail.com" target="_blank" rel="noopener noreferrer">Email: mottainai.contato@gmail.com</a></li>
            </ul>
        </div>
    </div>

    <hr />
    <div class="footer-base">
        <p>
            &copy; 2026 Mottainai. Todos os direitos reservados. Gestão
            Preditiva de Perecíveis.
        </p>
    </div>
</footer>
<script src="${pageContext.request.contextPath}/prototipo-figma/js/faq.js" defer></script>
</body></html>
