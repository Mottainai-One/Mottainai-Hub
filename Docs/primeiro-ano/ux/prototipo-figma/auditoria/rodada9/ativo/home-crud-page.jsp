<%--
O Servlet InicioServlet precisa existir e ser mapeado para /inicio (senão o link da sidebar quebra).
--%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Mottainai - Página inicial</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/crud.css" />
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/icons/casa.png" type="image/x-icon" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/crud-layout.css" />
</head>
<body data-pagina="inicio">
<div class="app">

    <!-- ===================== SIDEBAR ===================== -->
    <aside class="sidebar">
        <a href="${pageContext.request.contextPath}/inicio" class="sidebar-logo">
            <img src="${pageContext.request.contextPath}/assets/icons/logo.svg" alt="Mottainai" />
        </a>

        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/inicio" class="sidebar-item" data-pagina="inicio">
                <img class="sidebar-icone" src="${pageContext.request.contextPath}/assets/icons/home.svg" alt="" />
                <span>Página inicial</span>
            </a>
            <a href="${pageContext.request.contextPath}/empresas" class="sidebar-item" data-pagina="empresas">
                <img class="sidebar-icone" src="${pageContext.request.contextPath}/assets/icons/empresa.svg" alt="" />
                <span>Empresas</span>
            </a>
            <a href="${pageContext.request.contextPath}/lojas" class="sidebar-item" data-pagina="lojas">
                <img class="sidebar-icone" src="${pageContext.request.contextPath}/assets/icons/loja.svg" alt="" />
                <span>Lojas</span>
            </a>
            <a href="${pageContext.request.contextPath}/funcionarios" class="sidebar-item" data-pagina="funcionarios">
                <img class="sidebar-icone" src="${pageContext.request.contextPath}/assets/icons/cracha.svg" alt="" />
                <span>Funcionários</span>
            </a>
            <a href="${pageContext.request.contextPath}/cargos" class="sidebar-item" data-pagina="cargos">
                <img class="sidebar-icone" src="${pageContext.request.contextPath}/assets/icons/users.svg" alt="" />
                <span>Cargos</span>
            </a>
            <a href="${pageContext.request.contextPath}/contas" class="sidebar-item" data-pagina="contas">
                <img class="sidebar-icone" src="${pageContext.request.contextPath}/assets/icons/user.svg" alt="" />
                <span>Contas de usuários</span>
            </a>
            <a href="${pageContext.request.contextPath}/planos-administrativos" class="sidebar-item" data-pagina="planos">
                <img class="sidebar-icone" src="${pageContext.request.contextPath}/assets/icons/grafico.svg" alt="" />
                <span>Planos de assinatura</span>
            </a>
            <a href="${pageContext.request.contextPath}/enderecos" class="sidebar-item" data-pagina="enderecos">
                <img class="sidebar-icone" src="${pageContext.request.contextPath}/assets/icons/loja_alt.svg" alt="" />
                <span>Endereços</span>
            </a>
        </nav>

        <form id="logout-form" action="${pageContext.request.contextPath}/logout" method="post" hidden></form>
        <a href="${pageContext.request.contextPath}/logout" class="sidebar-sair" onclick="event.preventDefault(); document.getElementById('logout-form').requestSubmit();">
            <img class="sidebar-icone" src="${pageContext.request.contextPath}/assets/icons/logout.svg" alt="" />
            <span>Sair</span>
        </a>
    </aside>

    <!-- ===================== HEADER ===================== -->
    <header class="header">
        <h1 class="header-titulo">Visão geral administrativa</h1>
        <div class="header-usuario">
            <span class="header-nome">Fernando</span>
            <span class="header-avatar">
        <img src="${pageContext.request.contextPath}/assets/icons/user.svg" alt="Usuário" />
      </span>
        </div>
    </header>

    <!-- ===================== MAIN ===================== -->
    <main class="main">
        <h2 class="pagina-titulo">Visão geral</h2>
        <p class="pagina-subtitulo">
            Acompanhe os cadastros e a situação das empresas, lojas e usuários.
        </p>

        <div class="cards-resumo">
            <div class="card-resumo">
                <span class="card-resumo-label">Empresas ativas</span>
                <span class="card-resumo-valor">${totalEmpresasAtivas}</span>
                <span class="card-resumo-hint">
          ${totalEmpresas} cadastradas &middot; ${totalEmpresasInativas} inativas
        </span>
            </div>
            <div class="card-resumo">
                <span class="card-resumo-label">Lojas ativas</span>
                <span class="card-resumo-valor">${totalLojasAtivas}</span>
                <span class="card-resumo-hint">
          ${totalLojas} cadastradas &middot; ${totalLojasInativas} inativas
        </span>
            </div>
            <div class="card-resumo">
                <span class="card-resumo-label">Funcionários ativos</span>
                <span class="card-resumo-valor">${totalFuncionariosAtivos}</span>
                <span class="card-resumo-hint">
          ${totalFuncionarios} cadastrados &middot; ${totalFuncionariosInativos} inativos
        </span>
            </div>
            <div class="card-resumo">
                <span class="card-resumo-label">Contas de usuários ativas</span>
                <span class="card-resumo-valor">${totalContasAtivas}</span>
                <span class="card-resumo-hint">
          ${totalContas} cadastradas &middot; ${totalContasInativas} inativas
        </span>
            </div>
        </div>

        <div class="tabela-wrap">
            <div class="tabela-titulo">Cadastros recentes</div>
            <div class="tabela-subtitulo">Últimos registros adicionados ao sistema</div>

            <table class="tabela">
                <thead>
                <tr>
                    <th>Nome</th>
                    <th>Tipo de cadastro</th>
                    <th>Data</th>
                    <th>Situação</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty cadastrosRecentes}">
                        <tr>
                            <td colspan="4" class="tabela-vazia ativo">
                                Nenhum cadastro recente encontrado.
                            </td>
                        </tr>
                    </c:when>

                    <c:otherwise>
                        <c:forEach var="reg" items="${cadastrosRecentes}">
                            <tr>
                                <td>
                                    <c:out value="${reg.nome}" />
                                </td>

                                <td>
                                    <c:out value="${reg.tipo}" />
                                </td>

                                <td>
                                    <c:out value="${reg.dataFormatada}" />
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${reg.ativo}">
                            <span class="pill pill-ativo">
                                Ativo
                            </span>
                                        </c:when>

                                        <c:otherwise>
                            <span class="pill pill-inativo">
                                Inativo
                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>

            <div class="paginacao">
                <span class="paginacao-info">${fn:length(cadastrosRecentes)} cadastros recentes</span>
            </div>
        </div>
    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/crud.js"></script>
</body>
</html>