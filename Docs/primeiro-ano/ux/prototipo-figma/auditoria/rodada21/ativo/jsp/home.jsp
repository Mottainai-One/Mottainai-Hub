<%--
  Created by IntelliJ IDEA.
  User: 20260104-ieg
  Date: 08/10/2026
  Time: 17:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Mottainai - Gestão Preditiva de Perecíveis</title>

    <%--  CSS via contextPath para funcionar em qualquer deploy --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/modais.css" />
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/img/favicon.ico" type="image/x-icon" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
</head>
<body>
<input type="radio" name="modal" id="fechar" ${abrirLogin ? '' : 'checked'} hidden />
<header>
    <a href="${pageContext.request.contextPath}/home" class="logo">
        <img src="${pageContext.request.contextPath}/assets/img/mottainai-logo-completo.svg" alt="Mottainai" />
    </a>

    <nav>
        <ul>
            <li><a href="${pageContext.request.contextPath}/home" class="ativo">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/sobre-nos">Sobre nós</a></li>
            <li><a href="${pageContext.request.contextPath}/planos">Planos</a></li>
        </ul>
    </nav>

    <a href="https://mail.google.com/mail/?view=cm&amp;fs=1&amp;to=mottainai.contato@gmail.com" class="btn-contato" target="_blank" rel="noopener noreferrer">Entre em contato</a>
</header>

<main>
    <img id="background-line" src="${pageContext.request.contextPath}/assets/img/home-linhas-hero.png" alt="" />

    <!-- ===== HERO ===== -->
    <section id="home" class="hero">
        <div class="hero-texto">
            <h1>
                Seu estoque é <span class="destaque">bom demais</span> para ser
                desperdiçado.
            </h1>
            <p>
                Acreditamos que, com um bom controle, é possível reduzir perdas e
                aumentar a eficiência de seus lucros.
            </p>
            <div class="hero-botoes">
                <a href="#contato" class="btn btn-primario">Entre em contato</a>
                <a href="${pageContext.request.contextPath}/sobre-nos" class="btn btn-secundario">Saiba mais</a>
            </div>
        </div>
        <div class="hero-imagem">
            <img id="mock-left"
                 src="${pageContext.request.contextPath}/assets/img/home-mobile-profile-camila.png"
                 alt="Aplicativo Mottainai mostrando dashboard de estoque em dois celulares" />
            <img id="mock-right"
                 src="${pageContext.request.contextPath}/assets/img/home-mobile-lo-conversation.png" alt="" />
        </div>
    </section>

    <!-- ===== SISTEMA (4 cards) ===== -->
    <section id="sistema" class="sistema">
        <h2>Mottainai: O sistema completo para sua loja</h2>
        <div class="cards-sistema">
            <div class="card">
                <img src="${pageContext.request.contextPath}/assets/img/card-registrar.jpg"
                     alt="Pessoa registrando produto em caixa de autoatendimento" />
                <h3>Registre produtos</h3>
                <p>
                    Registre produtos com facilidade usando aparelhos de leitura de
                    códigos de barras ou digitando o seu código numérico.
                </p>
            </div>
            <div class="card">
                <img src="${pageContext.request.contextPath}/assets/img/card-validade.jpg"
                     alt="Mão escrevendo checklist em tablet" />
                <h3>Controle a validade</h3>
                <p>
                    Nosso sistema controla a validade dos produtos e considera a
                    quantidade em estoque e o fluxo de saída
                </p>
            </div>
            <div class="card">
                <img src="${pageContext.request.contextPath}/assets/img/card-alertas.jpg"
                     alt="Mão segurando celular com notificação de alerta" />
                <h3>Receba alertas e sugestões</h3>
                <p><!-- Texto real pendente --></p>
            </div>
            <div class="card">
                <img src="${pageContext.request.contextPath}/assets/img/card-comparar.jpg"
                     alt="Gráficos e ícones de análise de dados" />
                <h3>Compare dados e análises</h3>
                <p><!-- Texto real pendente --></p>
            </div>
        </div>
    </section>

    <!-- ===== ESTATÍSTICA (33%) ===== -->
    <section id="diferencial" class="estatistica">
        <img src="${pageContext.request.contextPath}/assets/img/rectangle-161.png"
             alt="Prateleira de mercado com bebidas e produtos perecíveis"
             class="estatistica-foto" />
        <div class="estatistica-conteudo">
            <p class="numero-grande">33%</p>
            <h2>
                Do custo anual ao longo da cadeia de suprimentos do varejo
                alimentar
            </h2>
            <p>
                Pode ser associado ao desperdício de alimentos, o que é
                prejudicial para o negócio e para o meio ambiente. O sistema
                Mottainai pode ajudar as empresas do setor à reduzirem essa taxa
                de perdas.
            </p>
        </div>
    </section>

    <!-- ===== WRAPPER LINHAS + FUNCIONALIDADES + ECOSSISTEMA + CTA ===== -->
    <div class="secao-linhas-decorativas">


        <section id="funcionalidades" class="funcionalidades">
            <h2>Funcionalidades Inteligentes</h2>
            <div class="grid-funcionalidades">
                <div class="func-card func-largo">
                    <div class="func-texto">
                        <img src="${pageContext.request.contextPath}/assets/icons/icone-validade.png"
                             alt="" class="func-icone" />
                        <h3>Gestão de Validade</h3>
                        <p>
                            Visão clara de todos os itens em estoque com vencimento
                            próximo, priorizando o que precisa ser vendido primeiro.
                        </p>
                    </div>
                    <img src="${pageContext.request.contextPath}/assets/img/home-validade-resumo.png"
                         alt="" class="func-ilustracao func-ilustracao-validade" />
                </div>

                <div class="func-card">
                    <img src="${pageContext.request.contextPath}/assets/icons/icone-sincronizacao.png"
                         alt="" class="func-icone" />
                    <h3>Versão gerente/estoquista</h3>
                    <p>
                        Conectividade fluida com os principais ERPs do mercado para
                        sincronização de estoque e vendas.
                    </p>
                </div>

                <div class="func-card">
                    <img src="${pageContext.request.contextPath}/assets/icons/icone-sincronizacao.png"
                         alt="" class="func-icone" />
                    <h3>Frente de caixa</h3>
                    <p>
                        Conectividade fluida com os principais ERPs do mercado para
                        sincronização de estoque e vendas.
                    </p>
                </div>

                <div class="func-card func-destaque">
                    <img src="${pageContext.request.contextPath}/assets/icons/icone-alertas.png"
                         alt="" class="func-icone" />
                    <h3>Alertas Inteligentes</h3>
                    <p>
                        Notificações diretas para as equipes de loja via mobile ou
                        desktop, garantindo ação imediata antes do vencimento.
                    </p>
                </div>

                <div class="func-card func-alto">
                    <img src="${pageContext.request.contextPath}/assets/icons/icone-dashboard.png"
                         alt="" class="func-icone" />
                    <h3>Dashboard Operacional</h3>
                    <p>
                        Monitoramento em tempo real do status de perda por categoria,
                        loja e departamento.
                    </p>
                    <img src="${pageContext.request.contextPath}/assets/img/home-dashboard-graficos.png"
                         alt="Gráficos de barras, listas e donut mostrando indicadores de perda"
                         class="func-ilustracao" />
                </div>

                <div class="func-card">
                    <img src="${pageContext.request.contextPath}/assets/icons/icone-sincronizacao.png"
                         alt="" class="func-icone" />
                    <h3>Integração ERP</h3>
                    <p>
                        Conectividade fluida com os principais ERPs do mercado para
                        sincronização de estoque e vendas.
                    </p>
                </div>

                <div class="func-card">
                    <img src="${pageContext.request.contextPath}/assets/icons/icone-sugestoes.svg"
                         alt="" class="func-icone" />
                    <h3>Sugestão de Ações</h3>
                    <p>
                        Recomendações automáticas de remarcação de preço ou doação com
                        base em dados históricos.
                    </p>
                </div>
            </div>
        </section>

        <!-- Ecossistema -->
        <section class="ecossistema">
            <img id="ecossistema-linha" class="home-blue-lines" src="${pageContext.request.contextPath}/assets/img/home-blue-lines-upper.svg" alt="" aria-hidden="true" />
            
            <div class="ecossistema-imagem">
                <img src="${pageContext.request.contextPath}/assets/img/home-mobile-ecossistema.png"
                     alt="Mão segurando celular mostrando automações ativas do aplicativo Mottainai" />
            </div>
            <div class="ecossistema-texto">
                <h2>
                    O Mottainai não é<br> apenas um
                    <span class="sublinha-salmao">aplicativo</span>
                </h2>
                <p>
                    É um ecossistema composto por uma plataforma web administrativa
                    e um aplicativo mobile operacional, integrados ao site do
                    supermercado.
                </p>
            </div>
        </section>

        <!-- CTA final -->
        <section id="contato" class="cta-final">
            <img id="cta-final-linha" class="home-blue-lines" src="${pageContext.request.contextPath}/assets/img/home-blue-lines-lower.svg" alt="" aria-hidden="true" />
            
            <div class="cta-final-conteudo">
                <div class="cta-final-texto">
                    <h2>
                        Transforme suas perdas em
                        <span class="destaque-salmao">oportunidade</span>
                    </h2>
                    <p>
                        Junte-se a dezenas de redes que já estão economizando e
                        operando de forma mais consciente com a Mottainai.
                    </p>
                    <div class="cta-botoes">
                        <label for="login" class="btn btn-primario">Login</label>
                        <a href="${pageContext.request.contextPath}/sobre-nos" class="btn btn-secundario">Saiba mais</a>
                    </div>
                </div>
                <div class="cta-final-imagem">
                    <img src="${pageContext.request.contextPath}/assets/img/home-monitor-predictive-alerts.png" width="624"
                         alt="Painel administrativo Mottainai" />
                    <img src="${pageContext.request.contextPath}/assets/img/mascote-lontra.png"
                         alt="Mascote lontra Mottainai, estoquista"
                         class="mascote-cta" />
                </div>
            </div>
        </section>
    </div>
</main>

<footer>
    <div class="footer-topo">
        <div class="footer-logo">
            <img class="footer-wordmark" src="${pageContext.request.contextPath}/assets/img/mottainai-wordmark-rodape.svg" alt="Mottainai" />
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
    <!-- ===== MODAL DE LOG-IN ===== -->
    <div class="modal">
      <input type="radio" name="modal" id="login" ${abrirLogin ? 'checked' : ''} hidden />
      <label for="fechar" aria-label="Fechar"></label>
      <div>
        <aside class="modal-identidade"><img class="modal-simbolo" src="${pageContext.request.contextPath}/assets/icons/simbolo-mottainai-laranja.svg" alt="" /><img class="modal-wordmark" src="${pageContext.request.contextPath}/assets/icons/wordmark-mottainai-claro.svg" alt="Mottainai" /></aside>
        <form id="login-form" method="post" action="${pageContext.request.contextPath}/login">
          <label for="fechar" aria-label="Fechar">&times;</label>
          <h2>Que bom ter você de volta!</h2>
          <p>Valorizamos ter você por aqui.</p>
          <p>Faça o seu log-in:</p>
          <label>E-mail
            <input type="email" name="email" placeholder="Digite aqui..." autocomplete="username" required />
          </label>
          <label>Senha
            <input type="password" name="password" placeholder="Digite aqui..." autocomplete="current-password" required />
          </label>
          <c:if test="${not empty erro}"><p role="alert"><c:out value="${erro}" /></p></c:if>
          <button type="submit">Entrar</button>
          <p>Não tem conta? <label for="cadastro">Faça cadastro</label></p>
        </form>
      </div>
    </div>

    <!-- ===== MODAL DE CADASTRO ===== -->
    <div class="modal">
      <input type="radio" name="modal" id="cadastro" hidden />
      <label for="fechar" aria-label="Fechar"></label>
      <div>
        <aside class="modal-identidade"><img class="modal-simbolo" src="${pageContext.request.contextPath}/assets/icons/simbolo-mottainai-laranja.svg" alt="" /><img class="modal-wordmark" src="${pageContext.request.contextPath}/assets/icons/wordmark-mottainai-claro.svg" alt="Mottainai" /></aside>
        <form id="cadastro-form">
          <label for="fechar" aria-label="Fechar">&times;</label>
          <h2>Junte-se ao futuro do varejo.</h2>
          <p>Mais que eficiência, gestão inteligente é sustentabilidade.</p>
          <p>Comece seu cadastro aqui:</p>
          <label>Nome completo
            <input type="text" placeholder="Digite aqui..." autocomplete="name" required />
          </label>
          <label>Documento identificador (CPF)...
            <input type="text" placeholder="Digite aqui..." inputmode="numeric" maxlength="14" required />
          </label>
          <label>E-mail
            <input type="email" placeholder="Digite aqui..." autocomplete="email" required />
          </label>
          <div>
            <label>Nova senha
              <input type="password" placeholder="Digite aqui..." minlength="8" autocomplete="new-password" required />
            </label>
            <label>Confirme a senha
              <input type="password" placeholder="Digite aqui..." minlength="8" autocomplete="new-password" required />
            </label>
          </div>
          <button type="button" aria-describedby="cadastro-pendente">Criar nova conta</button>
          <p id="cadastro-pendente" role="status">Cadastro externo ainda não disponível.</p>
          <p>Já tem uma conta? <label for="login">Faça login.</label></p>
        </form>
      </div>
    </div>
<script src="${pageContext.request.contextPath}/assets/js/modais.js"></script>
</body>
</html>
