<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Mottainai - Administradores</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/prototipo-figma/css/crud.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/prototipo-figma/css/fontes.css">
<link rel="shortcut icon" href="${pageContext.request.contextPath}/prototipo-figma/assets/img/favicon.ico" type="image/x-icon">
<link rel="stylesheet" href="${pageContext.request.contextPath}/prototipo-figma/css/crud-ux.css" />
</head>
<body data-pagina="administrations">
<div class="app">

    <!-- ===================== SIDEBAR ===================== -->
    <aside class="sidebar">
        <a href="${pageContext.request.contextPath}/inicio" class="sidebar-logo">
            <img src="${pageContext.request.contextPath}/prototipo-figma/assets/icons/logo.svg" alt="Mottainai" />
        </a>

        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/inicio" class="sidebar-item" data-pagina="inicio">
                <img class="sidebar-icone" src="${pageContext.request.contextPath}/prototipo-figma/assets/icons/home.svg" alt="" />
                <span>Página inicial</span>
            </a>
            <a href="${pageContext.request.contextPath}/empresas" class="sidebar-item" data-pagina="empresas">
                <img class="sidebar-icone" src="${pageContext.request.contextPath}/prototipo-figma/assets/icons/empresa.svg" alt="" />
                <span>Empresas</span>
            </a>
            <a href="${pageContext.request.contextPath}/lojas" class="sidebar-item" data-pagina="lojas">
                <img class="sidebar-icone" src="${pageContext.request.contextPath}/prototipo-figma/assets/icons/loja.svg" alt="" />
                <span>Lojas</span>
            </a>
            <a href="${pageContext.request.contextPath}/funcionarios" class="sidebar-item" data-pagina="funcionarios">
                <img class="sidebar-icone" src="${pageContext.request.contextPath}/prototipo-figma/assets/icons/cracha.svg" alt="" />
                <span>Funcionários</span>
            </a>
            <a href="${pageContext.request.contextPath}/cargos" class="sidebar-item" data-pagina="cargos">
                <img class="sidebar-icone" src="${pageContext.request.contextPath}/prototipo-figma/assets/icons/users.svg" alt="" />
                <span>Cargos</span>
            </a>
            <a href="${pageContext.request.contextPath}/contas" class="sidebar-item" data-pagina="contas">
                <img class="sidebar-icone" src="${pageContext.request.contextPath}/prototipo-figma/assets/icons/user.svg" alt="" />
                <span>Contas de usuários</span>
            </a>
            <a href="${pageContext.request.contextPath}/planos-administrativos" class="sidebar-item" data-pagina="planos">
                <img class="sidebar-icone" src="${pageContext.request.contextPath}/prototipo-figma/assets/icons/grafico.svg" alt="" />
                <span>Planos de assinatura</span>
            </a>
            <a href="${pageContext.request.contextPath}/enderecos" class="sidebar-item" data-pagina="enderecos">
                <img class="sidebar-icone" src="${pageContext.request.contextPath}/prototipo-figma/assets/icons/loja_alt.svg" alt="" />
                <span>Endereços</span>
            </a>
                    <a href="${pageContext.request.contextPath}/administrations" class="sidebar-item" data-pagina="administrations">
                <img class="sidebar-icone" src="${pageContext.request.contextPath}/prototipo-figma/assets/icons/user.svg" alt="" />
                <span>Administradores</span>
            </a>
        </nav>

        <form id="logout-form" action="${pageContext.request.contextPath}/logout" method="post" hidden></form>
        <a href="${pageContext.request.contextPath}/logout" class="sidebar-sair" onclick="event.preventDefault(); document.getElementById('logout-form').requestSubmit();">
            <img class="sidebar-icone" src="${pageContext.request.contextPath}/prototipo-figma/assets/icons/logout.svg" alt="" />
            <span>Sair</span>
        </a>
    </aside>

    <!-- ===================== HEADER ===================== -->
    <header class="header">
        <h1 class="header-titulo">Gestão de administradores</h1>
        <div class="perfil-administrativo">
            <button type="button" class="header-usuario perfil-trigger" aria-expanded="false" aria-controls="perfil-popup">
                <span class="header-nome">Administrador</span>
                <span class="header-avatar"><img src="${pageContext.request.contextPath}/prototipo-figma/assets/icons/user.svg" alt="" /></span>
            </button>
            <div class="perfil-popup" id="perfil-popup" hidden>
                <img class="perfil-foto" src="${pageContext.request.contextPath}/prototipo-figma/assets/icons/user.svg" alt="" />
                <strong class="perfil-nome">Administrador</strong>
                <p class="perfil-id">ID: <c:out value="${sessionScope.administrationId}" /></p>
                <p class="perfil-email">Email: <c:out value="${sessionScope.administrationEmail}" /></p>
                <form action="${pageContext.request.contextPath}/logout" method="post"><button type="submit" class="perfil-sair">Sair</button></form>
            </div>
        </div>
    </header>

    <main class="main">
        <h2 class="pagina-titulo">Administradores cadastrados</h2>
        <p class="pagina-subtitulo">Gestão de acesso administrativo. Administradores não podem ser excluídos.</p>
        <c:if test="${not empty mensagem}"><p class="feedback feedback-sucesso"><c:out value="${mensagem}" /></p></c:if>
        <c:if test="${not empty erro}"><p class="feedback feedback-erro" role="alert"><c:out value="${erro}" /></p></c:if>
        <form class="toolbar" action="${pageContext.request.contextPath}/administrations" method="get">
            <div class="busca"><input type="search" name="busca" value="<c:out value='${param.busca}' />" placeholder="Pesquisar por ID ou email..." aria-label="Pesquisar administradores" /></div>
            <button type="submit" class="btn btn-pesquisar">Pesquisar</button>
            <a href="${pageContext.request.contextPath}/administrations/new" class="btn btn-primario">+ Cadastrar administrador</a>
        </form>
        <div class="tabela-wrap"><table class="tabela">
            <thead><tr><th>ID</th><th>Email</th><th>Ações</th></tr></thead>
            <tbody>
            <c:if test="${empty administrations}"><tr><td colspan="3">Nenhum administrador encontrado.</td></tr></c:if>
            <c:forEach items="${administrations}" var="admin">
                <tr><td><c:out value="${admin.administrationId}" /></td><td><c:out value="${admin.email}" /></td>
                    <td class="col-acoes"><a class="icone-btn" href="${pageContext.request.contextPath}/administrations/${admin.administrationId}" title="Visualizar"><img src="${pageContext.request.contextPath}/prototipo-figma/assets/icons/eye.svg" alt="Visualizar" /></a>
                    <a class="icone-btn" href="${pageContext.request.contextPath}/administrations/${admin.administrationId}/edit" title="Editar"><img src="${pageContext.request.contextPath}/prototipo-figma/assets/icons/edit.svg" alt="Editar" /></a></td></tr>
            </c:forEach>
            </tbody>
        </table></div>
    </main>
</div>
<div id="modal-administration-criar" data-administration class="modal-overlay ${administrationFormOpen ? 'aberto' : ''}">
 <div class="modal">
    <div class="modal-cabecalho"><h2>${isEdit ? 'Editar administrador' : 'Cadastrar administrador'}</h2><a class="modal-fechar" href="${pageContext.request.contextPath}/administrations" aria-label="Fechar">×</a></div>
    <form action="${pageContext.request.contextPath}/administrations${isEdit ? '/' : ''}${isEdit ? administrationId : ''}${isEdit ? '/update' : ''}" method="post">
        <div class="campo"><label for="administration-email">Email</label><input id="administration-email" type="email" name="email" maxlength="100" required value="<c:out value='${administrationForm.email}' />" autocomplete="off" /></div>
        <div class="campo"><label for="administration-password">${isEdit ? 'Nova senha (opcional)' : 'Senha'}</label><input id="administration-password" type="password" name="password" maxlength="72" autocomplete="new-password" ${isEdit ? '' : 'required'} /></div>
        <p>Na edição, deixe a senha vazia para manter a atual. Limite de 72 bytes em UTF-8.</p>
        <div class="modal-rodape"><a href="${pageContext.request.contextPath}/administrations" class="btn btn-secundario">Cancelar</a><button type="submit" class="btn btn-primario">Salvar</button></div>
    </form>
 </div>
</div>
<div id="modal-administration-ver" data-administration class="modal-overlay ${administrationView ? 'aberto' : ''}">
 <div class="modal"><div class="modal-cabecalho"><h2>Administrador</h2><a class="modal-fechar" href="${pageContext.request.contextPath}/administrations" aria-label="Fechar">×</a></div>
    <p>ID: <c:out value="${administration.administrationId}" /></p><p>Email: <c:out value="${administration.email}" /></p>
 </div>
</div>
<script src="${pageContext.request.contextPath}/prototipo-figma/js/crud.js"></script>
<script src="${pageContext.request.contextPath}/prototipo-figma/js/crud-ux.js"></script>
</body></html>
