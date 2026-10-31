<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="pt-BR">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Mottainai | Planos</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/planos.css" />
  </head>
  <body>
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

      <a href="${pageContext.request.contextPath}/home#contato" class="btn-contato">Entre em contato</a>
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
            <a href="${pageContext.request.contextPath}/home#contato">
              <div class="btn-contato">Entre em contato</div>
            </a>
            <a href="#saiba-mais">
              <!-- SUBSTITUI PELO CERTO -->
              <div class="btn-saiba-mais">Saiba mais</div>
            </a>
          </div>
        </div>
        <div id="right">
          <img src="${pageContext.request.contextPath}/assets/img/mascote1.png" alt="Lontra - Mascote Mottainai" />
        </div>
      </section>

      <section id="escolha-plano">
        <h2>Escolha seu <span>plano ideal:</span></h2>
        <div id="toggle-plano">
          <div id="retangulo">
            <div class="opcao" id="mensal">Mensal</div>
          </div>
          <div class="opcao" id="anual">Anual</div>
        </div>

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
            <div class="btn-plano">Contratar plano</div>
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
            <div class="btn-plano">Contratar plano</div>
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
            <div class="btn-plano">Contratar plano</div>
          </div>
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
            <a href="${pageContext.request.contextPath}/home#contato">
              <div class="btn-contato">Entre em contato</div>
            </a>
            <a href="#saiba-mais">
              <div class="btn-saiba-mais">Saiba mais</div>
            </a>
          </div>
        </div>
      </section>
    </main>

    <script src="${pageContext.request.contextPath}/assets/js/planos.js"></script>
  </body>
</html>
