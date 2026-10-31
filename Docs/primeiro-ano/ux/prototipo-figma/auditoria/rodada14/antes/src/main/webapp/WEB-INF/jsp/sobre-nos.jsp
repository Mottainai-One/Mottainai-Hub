<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mottainai - Sobre nós</title>
    <%-- Ajuste do caminho do CSS --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sobre-nos.css">
</head>
<body>
<header>
    <div id="logo">
        <img src="${pageContext.request.contextPath}/assets/img/group-132.png" alt="Mottainai Logo">
    </div>
    <nav>
        <div>
            <a href="${pageContext.request.contextPath}/home" class="btn">Home</a>
        </div>
        <div>
            <p id="pag-selecionada" class="btn">Sobre Nós</p>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/planos" class="btn">Planos</a>
        </div>
    </nav>
    <div>
        <a href="${pageContext.request.contextPath}/home#contato" class="contato-button btn">Entre em contato</a>
    </div>
</header>

<main>
    <!-- hero carrossel -->
    <section class="hero-carrossel">
        <input type="radio" name="hero" id="hero-1" class="hero-radio">
        <input type="radio" name="hero" id="hero-2" class="hero-radio">
        <input type="radio" name="hero" id="hero-3" class="hero-radio">
        <input type="radio" name="hero" id="hero-4" class="hero-radio">
        <div class="hero-track">
            <div class="div-h1 slide" id="significado">
                <h1 class="hero-h1">Significado</h1>
                <p class="p-hero">Mottainai (もったいない) é uma expressão e filosofia japonesa que pode ser traduzida como "que desperdício!" ou "não desperdice".
                    A filosofia ensina que tudo tem uma essência valiosa e merece respeito.</p>
                <label for="hero-4" class="car-btn prev" aria-label="Anterior">&#10094;</label>
                <label for="hero-2" class="car-btn next" aria-label="Próximo">&#10095;</label>
            </div>
            <div class="div-h1 slide" id="proposta">
                <h1 class="hero-h1">Proposta</h1>
                <p class="p-hero">Inspirados nesse conceito japonês que valoriza tudo o que ainda possui utilidade, desenvolvemos uma plataforma que utiliza análise de dados e inteligência preditiva para tornar a gestão de estoques mais eficiente.</p>
                <label for="hero-1" class="car-btn prev" aria-label="Anterior">&#10094;</label>
                <label for="hero-3" class="car-btn next" aria-label="Próximo">&#10095;</label>
            </div>
            <div class="div-h1 slide" id="nosso-ideal">
                <h1 class="hero-h1">Nosso ideal</h1>
                <p class="p-hero">Alinhado ao ODS 12.3 da ONU, o Mottainai acredita que tecnologia e sustentabilidade caminham juntas. Porque, com a informação certa no momento certo, é possível transformar desperdício em eficiência e construir um varejo mais inteligente e sustentável.</p>
                <label for="hero-2" class="car-btn prev" aria-label="Anterior">&#10094;</label>
                <label for="hero-4" class="car-btn next" aria-label="Próximo">&#10095;</label>
            </div>
            <div class="div-h1 slide" id="nosso-produto">
                <h1 class="hero-h1">Nosso produto</h1>
                <p class="p-hero">Mais do que acompanhar datas de validade, nossa tecnologia antecipa riscos de perdas, auxilia na tomada de decisões e reduz desperdícios antes que eles aconteçam.</p>
                <label for="hero-3" class="car-btn prev" aria-label="Anterior">&#10094;</label>
                <label for="hero-1" class="car-btn next" aria-label="Próximo">&#10095;</label>
            </div>
        </div>
        <div class="car-dots">
            <label for="hero-1" aria-label="Slide 1"></label>
            <label for="hero-2" aria-label="Slide 2"></label>
            <label for="hero-3" aria-label="Slide 3"></label>
            <label for="hero-4" aria-label="Slide 4"></label>
        </div>
    </section>

    <!-- equipe -->
    <section class="equipe-com-linhas">
        <div class="about-blue-lines" aria-hidden="true">
            <img class="about-blue-lines-upper" src="${pageContext.request.contextPath}/assets/img/about-blue-lines-upper.svg" alt="" />
            <img class="about-blue-lines-lower" src="${pageContext.request.contextPath}/assets/img/about-blue-lines-lower.svg" alt="" />
        </div>
        <div>
            <h2 id="nossa-equipe">Nossa Equipe</h2>
        </div>

        <h3 id="primeiro-ano" class="titulo-ano">1º ANO</h3>
        <div class="bloco-ano">
            <div class="carrossel-wrap">
                <div class="carrossel">
                    <div class="cartoes">
                        <img src="${pageContext.request.contextPath}/assets/img/giovanna.jpg" alt="Giovanna Sozinha">
                        <span class="span-cartoes">UX/UI and Frontend Dev</span>
                        <strong>Giovanna Sartori</strong>
                    </div>
                    <div class="cartoes">
                        <img src="${pageContext.request.contextPath}/assets/img/gustavo.png" alt="Gustavo Sozinho">
                        <span class="span-cartoes">Database administrator</span>
                        <strong>Gustavo Cardoso</strong>
                    </div>
                    <div class="cartoes">
                        <img src="${pageContext.request.contextPath}/assets/img/joaov.png" alt="João Victor Sozinho">
                        <span class="span-cartoes">Full-stack developer</span>
                        <strong>João Rodrigues</strong>
                    </div>
                    <div class="cartoes">
                        <img src="${pageContext.request.contextPath}/assets/img/luana.png" alt="Luana Sozinha">
                        <span class="span-cartoes">UX/UI Designer</span>
                        <strong>Luana Pedroso</strong>
                    </div>
                    <div class="cartoes">
                        <img src="${pageContext.request.contextPath}/assets/img/miguel.png" alt="Miguel Quadros">
                        <span class="span-cartoes">Database administrator</span>
                        <strong>Miguel Quadros</strong>
                    </div>
                    <div class="cartoes">
                        <img src="${pageContext.request.contextPath}/assets/img/pedro.png" alt="Pedro Henrique">
                        <span class="span-cartoes">Back-end developer</span>
                        <strong>Pedro Henrique</strong>
                    </div>
                </div>
            </div>
        </div>

        <h3 id="segundo-ano" class="titulo-ano">2º ANO</h3>
        <div class="bloco-ano">
            <div class="carrossel-wrap">
                <div class="carrossel">
                    <div class="cartoes">
                        <img src="${pageContext.request.contextPath}/assets/img/anatimie.png" alt="Ana Araújo">
                        <span class="span-cartoes">Análise e Gestão de Dados</span>
                        <strong>Ana Araújo</strong>
                    </div>
                    <div class="cartoes">
                        <img src="${pageContext.request.contextPath}/assets/img/tutu.png" alt="Arthur do Vale">
                        <span class="span-cartoes">Analista de Dados</span>
                        <strong>Arthur do Vale</strong>
                    </div>
                    <div class="cartoes">
                        <img src="${pageContext.request.contextPath}/assets/img/joaop.png" alt="João Capelli">
                        <span class="span-cartoes">Front-end developer</span>
                        <strong>João Capelli</strong>
                    </div>
                    <div class="cartoes">
                        <img src="${pageContext.request.contextPath}/assets/img/bella.png" alt="Isabella Gimenes">
                        <span class="span-cartoes">UX/UI Design</span>
                        <strong>Isabella Gimenes</strong>
                    </div>
                    <div class="cartoes">
                        <img src="${pageContext.request.contextPath}/assets/img/kevin.png" alt="Kevin Jun">
                        <span class="span-cartoes">Back-end Developer</span>
                        <strong>Kevin Jun</strong>
                    </div>
                    <div class="cartoes">
                        <img src="${pageContext.request.contextPath}/assets/img/sarah.png" alt="Rebecca Paulucci">
                        <span class="span-cartoes">Back-end developer</span>
                        <strong>Rebecca Paulucci</strong>
                    </div>
                </div>
            </div>
        </div>
    </section>
</main>

<footer>
    <div class="footer-topo">
        <div class="footer-logo">
            <img src="${pageContext.request.contextPath}/assets/img/group-132.png" alt="Mottainai" class="logo">
            <p>Bom demais para ser desperdiçado,</p>
        </div>
        <div class="footer-coluna">
            <h5>Página inicial</h5>
            <ul><li>Diferencial</li><li>Funcionalidades</li><li>Sistema</li></ul>
        </div>
        <div class="footer-coluna">
            <h5>Sobre nós</h5>
            <ul><li>Nossa equipe</li><li>Nosso propósito</li><li>No que acreditamos</li></ul>
        </div>
        <div class="footer-coluna">
            <h5>Planos</h5>
            <ul><li>Condições</li><li>Termos de Uso</li><li>Contato</li></ul>
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
    <hr>
    <div class="footer-base">
        <p>&copy; 2026 Mottainai. Todos os direitos reservados. Gestão Preditiva de Perecíveis.</p>
    </div>
</footer>
</body>
</html>