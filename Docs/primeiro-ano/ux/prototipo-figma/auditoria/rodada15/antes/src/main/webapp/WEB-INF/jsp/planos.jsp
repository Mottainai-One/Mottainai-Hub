<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="pt-BR">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Mottainai | Planos</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/planos.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
</head>
  <body class="pagina-planos">
    <header>
      <a href="${pageContext.request.contextPath}/home" class="logo">
        <img src="${pageContext.request.contextPath}/assets/img/logo.svg" alt="Mottainai" />
      </a>

      <nav>
        <ul>
          <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
          <li><a href="${pageContext.request.contextPath}/sobre-nos">Sobre nós</a></li>
          <li><a href="${pageContext.request.contextPath}/planos" class="ativo">Planos</a></li>
        </ul>
      </nav>

      <a href="https://mail.google.com/mail/?view=cm&amp;fs=1&amp;to=mottainai.contato@gmail.com" class="btn-contato botao-com-hover">Entre em contato</a>
    </header>
    <main>
      <section id="hero">
        <div id="background-lines">
          <img src="${pageContext.request.contextPath}/assets/img/blue-lines.svg" />
        </div>
        <div id="left">
          <strong>Desperdício transformado em R$</strong>
          <h1>
            Conheça nossos planos <br />
            de contratação
          </h1>
          <p>
            Cada plano de contratação foi pensado para melhor atender um tamanho
            de negócio, oferecendo um preço justo e recursos cuidadosamente
            medidos.
          </p>
          <div class="btns">
            <a href="https://mail.google.com/mail/?view=cm&amp;fs=1&amp;to=mottainai.contato@gmail.com">
              <div class="btn-contato botao-com-hover">Entre em contato</div>
            </a>
            <a href="#saiba-mais">
              <!-- SUBSTITUI PELO CERTO -->
              <div class="btn-saiba-mais botao-com-hover">Saiba mais</div>
            </a>
          </div>
        </div>
        <div id="right">
          <img src="${pageContext.request.contextPath}/assets/img/mascote1.png" alt="Lontra - Mascote Mottainai" />
        </div>
      </section>

      <section id="escolha-plano">
        <h2>Escolha seu <span>plano ideal:</span></h2>
        <div id="toggle-plano" role="group" aria-label="Periodicidade de cobrança dos planos">
          <div id="retangulo">
            <button type="button" class="opcao" id="mensal">Mensal</button>
          </div>
          <button type="button" class="opcao" id="anual">Anual</button>
        </div>

        <div class="carrossel-planos">
<button type="button" class="seta" id="seta-anterior" aria-label="Plano anterior">&#10094;</button>
<div class="container">
          <div class="card-plano">
            <strong class="nome">Essentials</strong>
            <p class="descricao">Para operações locais e pequenos varejos.</p>
            <span class="preco">
              <strong>R$ 1.200</strong>
              <span>/mês</span>
            </span>
            <ul class="atributos">
              <li>Até 3 usuários simultâneos</li>
              <li>Integração ERP via API básica</li>
              <li>Dashboard de vencimentos</li>
              <li>Previsão por IA avançada</li>
            </ul>
            <a class="btn-plano botao-com-hover" href="https://mail.google.com/mail/?view=cm&amp;fs=1&amp;to=mottainai.contato@gmail.com" target="_blank" rel="noopener noreferrer">Contratar plano</a>
          </div>

          <div class="card-plano" id="principal">
            <div class="blur">
              <img src="${pageContext.request.contextPath}/assets/img/shadow-planos.png" alt="" />
            </div>
            <div class="tag">Mais popular</div>
            <strong class="nome">Professional</strong>
            <p class="descricao">Ideal para redes regionais em crescimento.</p>
            <span class="preco">
              <strong>R$ 3.500</strong>
              <span>/mês</span>
            </span>
            <ul class="atributos">
              <li>Até 15 usuários simultâneos</li>
              <li>Integração ERP nativa (SAP, Oracle)</li>
              <li>Previsão de demanda por IA</li>
              <li>Suporte prioritário 24/7</li>
            </ul>
            <a class="btn-plano botao-com-hover" href="https://mail.google.com/mail/?view=cm&amp;fs=1&amp;to=mottainai.contato@gmail.com" target="_blank" rel="noopener noreferrer">Contratar plano</a>
          </div>

          <div class="card-plano">
            <strong class="nome">Enterprise</strong>
            <span class="preco">
              <strong>Customizado</strong>
            </span>
            <ul class="atributos">
              <li>Usuários ilimitados</li>
              <li>Infraestrutura dedicada (On- premise/Cloud)</li>
              <li>Treinamento in-loco e onboarding VIP</li>
              <li>Módulos ESG e relatórios de impacto</li>
            </ul>
            <a class="btn-plano botao-com-hover" href="https://mail.google.com/mail/?view=cm&amp;fs=1&amp;to=mottainai.contato@gmail.com" target="_blank" rel="noopener noreferrer">Contratar plano</a>
          </div>
        </div>
<button type="button" class="seta" id="seta-proximo" aria-label="Próximo plano">&#10095;</button>
</div>
      </section>

      <section id="duvidas">
        <div id="image-duvidas">
          <img src="${pageContext.request.contextPath}/assets/img/story-set-plans.svg" alt="" />
        </div>
        <div id="conteudo-duvidas">
          <h2>Dúvidas sobre o plano ideal?</h2>
          <p>
            Valorizamos que nossos clientes sintam-se satisfeitos com nossos
            serviços e possam usufruir do plano que melhor lhes atende. Se sente
            que precisa de mais detalhes ou tem duvidas sobre como nosso sistema
            pode operar em sua(s) loja(s), contate-nos através de um dos
            contatos comerciais ou acesse nossa página FAQ:
          </p>
          <div class="btns">
            <a href="https://mail.google.com/mail/?view=cm&amp;fs=1&amp;to=mottainai.contato@gmail.com">
              <div class="btn-contato botao-com-hover">Entre em contato</div>
            </a>
            <a href="#saiba-mais">
              <div class="btn-saiba-mais botao-com-hover">Saiba mais</div>
            </a>
          </div>
        </div>
      </section>
    </main>
<footer>
    <div class="footer-topo">
        <div class="footer-logo">
            <img src="${pageContext.request.contextPath}/assets/img/home-logo-rodape.png" alt="Mottainai" />
            <p>Bom demais para ser desperdiçado,</p>
        </div>

        <div class="footer-coluna">
            <h5>Página inicial</h5>
            <ul>
                <li>Diferencial</li>
                <li>Funcionalidades</li>
                <li>Sistema</li>
            </ul>
        </div>

        <div class="footer-coluna">
            <h5>Sobre nós</h5>
            <ul>
                <li>Nossa equipe</li>
                <li>Nosso propósito</li>
                <li>No que acreditamos</li>
            </ul>
        </div>

        <div class="footer-coluna">
            <h5>Planos</h5>
            <ul>
                <li>Condições</li>
                <li>Termos de Uso</li>
                <li>Contato</li>
            </ul>
        </div>

        <div class="footer-coluna">
            <h5>Nos siga nas Redes!</h5>
            <ul>
                <li>Instagram: @mottainai_app</li>
                <li>Tel Empresarial: (+55) 11 91234-5678</li>
                <li>Email: mottainai@gmail.com.br</li>
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

    <script src="${pageContext.request.contextPath}/assets/js/planos.js"></script>
  </body>
</html>
