<%--
  Página de gerenciamento de planos de assinatura.

  Recebe do PlanoServlet (listagem normal):
    - planos (lista de Plano)
    - paginaAtual, totalPaginas

  Recebe do PlanoServlet (só quando acao=editar):
    - planoEditar (Plano)

  Recebe do PlanoServlet (só quando acao=ver):
    - planoVer (Plano)

  Recebe do PlanoServlet (só quando acao=excluir):
    - planoExcluir (Plano)
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Mottainai - Planos de assinatura</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/crud.css" />
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/icons/grafico.svg" type="image/x-icon" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/crud-layout.css" />
</head>
<body data-pagina="planos">
<div class="app">

    <!-- ===================== SIDEBAR ===================== -->
    <aside class="sidebar">
        <a href="${pageContext.request.contextPath}/inicio" class="sidebar-logo">
            <img src="${pageContext.request.contextPath}/assets/icons/logo-administrativo.svg" alt="Mottainai" />
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
        <h1 class="header-titulo">Controle de planos de assinatura</h1>
        <div class="perfil-administrativo">
            <button type="button" class="header-usuario perfil-trigger" aria-expanded="false" aria-controls="perfil-popup">
                <span class="header-nome">Administrador</span>
                <span class="header-avatar"><img src="${pageContext.request.contextPath}/assets/icons/user.svg" alt="" /></span>
            </button>
            <div class="perfil-popup" id="perfil-popup" hidden aria-labelledby="perfil-titulo">
                <strong class="perfil-titulo" id="perfil-titulo">Minha conta</strong>
                <p class="perfil-subtitulo">Informações do perfil</p>
                <div class="perfil-avatar"><img src="${pageContext.request.contextPath}/assets/icons/perfil-usuario-figma.svg" alt="" /></div>
                <p class="perfil-email"><c:out value="${sessionScope.administrationEmail}" /></p>
                <span class="perfil-cargo">Administrador do sistema</span>
                <form action="${pageContext.request.contextPath}/logout" method="post"><button type="submit" class="perfil-sair"><img src="${pageContext.request.contextPath}/assets/icons/logout.svg" alt="" />Sair da conta</button></form>
            </div>
        </div>
    </header>
    <main class="main">

    <!-- ===================== MAIN ===================== -->
    <c:if test="${not empty mensagem}">
        <div class="feedback feedback-sucesso">
            <c:out value="${mensagem}" />
        </div>
    </c:if>

    <c:if test="${not empty erro}">
        <div class="feedback feedback-erro">
            <c:out value="${erro}" />
        </div>
    </c:if>
    
        <h2 class="pagina-titulo">Planos cadastrados</h2>
        <p class="pagina-subtitulo">Gerencie os planos de assinatura disponíveis para as empresas.</p>

        <form class="toolbar" action="${pageContext.request.contextPath}/planos-administrativos" method="get">
            <div class="busca">
                <img class="busca-icone" src="${pageContext.request.contextPath}/assets/icons/search.svg" alt="" />
                <input type="text" name="busca" value="<c:out value='${param.busca}' />"
                       placeholder="Pesquisar por nome ou descrição..." />
            </div>
            <select class="filtro" name="situacao">
                <option value="">Todas as situações</option>
                <option value="ativo"   ${param.situacao == 'ativo'   ? 'selected' : ''}>Ativo</option>
                <option value="inativo" ${param.situacao == 'inativo' ? 'selected' : ''}>Inativo</option>
            </select>
            <button type="submit" class="btn btn-secundario">Pesquisar</button>
            <a href="${pageContext.request.contextPath}/planos-administrativos?acao=criar" class="btn btn-primario">
                + Cadastrar plano
            </a>
        </form>

        <div class="tabela-wrap">
            <table class="tabela">
                <thead>
                <tr>
                    <th>Nome</th>
                    <th>Descrição</th>
                    <th>Preço</th>
                    <th>Limite de lojas</th>
                    <th>Limite de usuários</th>
                    <th>Situação</th>
                    <th>Ações</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty planos}">
                        <tr>
                            <td colspan="7">
                                <div class="tabela-vazia ativo">Nenhum plano encontrado.</div>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="plano" items="${planos}">
                            <tr>
                                <td><c:out value="${plano.name}" /></td>
                                <td><c:out value="${plano.description}" /></td>
                                <td>
                                    R$ <fmt:formatNumber value="${plano.price}" type="number"
                                                         minFractionDigits="2" maxFractionDigits="2" />
                                </td>
                                <td><c:out value="${plano.storeLimit}" /></td>
                                <td><c:out value="${plano.userLimit}" /></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${plano.active}">
                                            <span class="pill pill-ativo">Ativo</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="pill pill-inativo">Inativo</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="col-acoes">
                                    <a href="${pageContext.request.contextPath}/planos-administrativos?acao=ver&id=${plano.planId}"
                                       class="icone-btn" title="Visualizar">
                                        <img src="${pageContext.request.contextPath}/assets/icons/eye.svg" alt="Visualizar" />
                                    </a>
                                    <a href="${pageContext.request.contextPath}/planos-administrativos?acao=editar&id=${plano.planId}"
                                       class="icone-btn" title="Editar">
                                        <img src="${pageContext.request.contextPath}/assets/icons/edit.svg" alt="Editar" />
                                    </a>
                                    <a href="${pageContext.request.contextPath}/planos-administrativos?acao=excluir&id=${plano.planId}"
                                       class="icone-btn icone-btn-perigo" title="Excluir">
                                        <img src="${pageContext.request.contextPath}/assets/icons/trash.svg" alt="Excluir" />
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>

            <div class="paginacao">
                <span class="paginacao-info">Página ${paginaAtual} de ${totalPaginas}</span>
                <div class="paginacao-controles">
                    <c:choose>
                        <c:when test="${paginaAtual > 1}">
                            <c:url var="paginacaoUrl1" value="/planos-administrativos">
                                <c:param name="pagina" value="${paginaAtual - 1}" />
                                <c:param name="busca" value="${param.busca}" />
                                <c:param name="situacao" value="${param.situacao}" />
                            </c:url>
                            <a href="${paginacaoUrl1}"
                               class="paginacao-btn">Anterior</a>
                        </c:when>
                        <c:otherwise>
                            <button class="paginacao-btn" disabled>Anterior</button>
                        </c:otherwise>
                    </c:choose>

                    <c:forEach begin="1" end="${totalPaginas}" var="pag">
                        <c:choose>
                            <c:when test="${pag == paginaAtual}">
                                <button class="paginacao-btn ativo">${pag}</button>
                            </c:when>
                            <c:otherwise>
                                <c:url var="paginacaoUrl2" value="/planos-administrativos">
                                <c:param name="pagina" value="${pag}" />
                                <c:param name="busca" value="${param.busca}" />
                                <c:param name="situacao" value="${param.situacao}" />
                            </c:url>
                            <a href="${paginacaoUrl2}"
                                   class="paginacao-btn">${pag}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <c:choose>
                        <c:when test="${paginaAtual < totalPaginas}">
                            <c:url var="paginacaoUrl3" value="/planos-administrativos">
                                <c:param name="pagina" value="${paginaAtual + 1}" />
                                <c:param name="busca" value="${param.busca}" />
                                <c:param name="situacao" value="${param.situacao}" />
                            </c:url>
                            <a href="${paginacaoUrl3}"
                               class="paginacao-btn">Próximo</a>
                        </c:when>
                        <c:otherwise>
                            <button class="paginacao-btn" disabled>Próximo</button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- ============================================================
     MODAIS DE PLANO DE ASSINATURA
     ============================================================ -->

<!-- Modal: Cadastrar plano -->
<div class="modal-overlay ${param.acao == 'criar' || not empty planoCriar ? 'aberto' : ''}"
     id="modal-plano-criar">
    <div class="modal">
        <div class="modal-cabecalho">
            <h3 class="modal-titulo">Cadastrar plano de assinatura</h3>
            <a href="${pageContext.request.contextPath}/planos-administrativos" class="modal-fechar">&times;</a>
        </div>
        <p class="modal-subtitulo">Preencha os dados para cadastrar. * Campos obrigatórios.</p>

        <form class="modal-corpo"
              action="${pageContext.request.contextPath}/planos-administrativos"
              method="post"
              data-formulario="plano"
              novalidate>
            <input type="hidden" name="acao" value="cadastrar" />

            <div class="campo campo-completo">
                <label>Nome do plano <span class="obrigatorio">*</span></label>
                <input type="text" name="name" value="<c:out value='${planoCriar.name}' />" placeholder="Ex.: Professional" />
                <span class="campo-erro" data-erro-de="name">
                    <c:out value="${fieldErrors.name}" />
                </span>
            </div>
            <div class="campo campo-completo">
                <label>Descrição <span class="obrigatorio">*</span></label>
                <input type="text" name="description" value="<c:out value='${planoCriar.description}' />" placeholder="Descrição do plano" />
                <span class="campo-erro" data-erro-de="description">
                    <c:out value="${fieldErrors.description}" />
                </span>
            </div>
            <div class="campo">
                <label>Preço (R$) <span class="obrigatorio">*</span></label>
                <input type="text" name="price" value="<c:out value='${planoCriar.price}' />" placeholder="Ex.: 349,90" data-mascara="moeda" />
                <span class="campo-erro" data-erro-de="price">
                    <c:out value="${fieldErrors.price}" />
                </span>
            </div>
            <div class="campo">
                <label>Situação <span class="obrigatorio">*</span></label>
                <select name="active">
                    <option value="">Selecione</option>

                    <option value="true"
                    ${planoCriar.active == true ? 'selected' : ''}>
                        Ativo
                    </option>

                    <option value="false"
                    ${planoCriar.active == false ? 'selected' : ''}>
                        Inativo
                    </option>
                </select>
                <span class="campo-erro" data-erro-de="active">
                    <c:out value="${fieldErrors.active}" />
                </span>
            </div>
            <div class="campo">
                <label>Limite de lojas <span class="obrigatorio">*</span></label>
                <input type="number" name="storeLimit" value="<c:out value='${planoCriar.storeLimit}' />" min="1" />
                <span class="campo-erro" data-erro-de="storeLimit">
                    <c:out value="${fieldErrors.storeLimit}" />
                </span>
            </div>
            <div class="campo">
                <label>Limite de usuários <span class="obrigatorio">*</span></label>
                <input type="number" name="userLimit" value="<c:out value='${planoCriar.userLimit}' />" min="1" />
                <span class="campo-erro" data-erro-de="userLimit">
                    <c:out value="${fieldErrors.userLimit}" />
                </span>
            </div>

            <div class="modal-rodape campo-completo">
                <a href="${pageContext.request.contextPath}/planos-administrativos" class="btn btn-secundario">Cancelar</a>
                <button type="submit" class="btn btn-primario">Cadastrar plano</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal: Editar plano -->
<div class="modal-overlay ${not empty planoEditar ? 'aberto' : ''}" id="modal-plano-editar">
    <div class="modal">
        <div class="modal-cabecalho">
            <h3 class="modal-titulo">Editar plano de assinatura</h3>
            <a href="${pageContext.request.contextPath}/planos-administrativos" class="modal-fechar">&times;</a>
        </div>
        <p class="modal-subtitulo">Revise os dados do registro. * Campos obrigatórios.</p>

        <form class="modal-corpo"
              action="${pageContext.request.contextPath}/planos-administrativos"
              method="post"
              data-formulario="plano"
              novalidate>
            <input type="hidden" name="acao" value="atualizar" />
            <input type="hidden" name="id" value="${planoEditar.planId}" />

            <div class="campo campo-completo">
                <label>Nome do plano <span class="obrigatorio">*</span></label>
                <input type="text" name="name" value="<c:out value='${planoEditar.name}' />" />
                <span class="campo-erro" data-erro-de="name">
                    <c:out value="${fieldErrors.name}" />
                </span>
            </div>
            <div class="campo campo-completo">
                <label>Descrição <span class="obrigatorio">*</span></label>
                <input type="text" name="description" value="<c:out value='${planoEditar.description}' />" />
                <span class="campo-erro" data-erro-de="description">
                    <c:out value="${fieldErrors.description}" />
                </span>
            </div>
            <div class="campo">
                <label>Preço (R$) <span class="obrigatorio">*</span></label>
                <input type="text" name="price"
                       value="<fmt:formatNumber value='${planoEditar.price}' type='number' minFractionDigits='2' maxFractionDigits='2' />"
                       data-mascara="moeda" />
                <span class="campo-erro" data-erro-de="price">
                    <c:out value="${fieldErrors.price}" />
                </span>
            </div>
            <div class="campo">
                <label>Situação <span class="obrigatorio">*</span></label>
                <select name="active">
                    <option value="true"  ${planoEditar.active ? 'selected' : ''}>Ativo</option>
                    <option value="false" ${!planoEditar.active ? 'selected' : ''}>Inativo</option>
                </select>
                <span class="campo-erro" data-erro-de="active">
                    <c:out value="${fieldErrors.active}" />
                </span>
            </div>
            <div class="campo">
                <label>Limite de lojas <span class="obrigatorio">*</span></label>
                <input type="text" name="storeLimit" value="<c:out value='${planoEditar.storeLimit}' />" />
                <span class="campo-erro" data-erro-de="storeLimit">
                    <c:out value="${fieldErrors.storeLimit}" />
                </span>
            </div>
            <div class="campo">
                <label>Limite de usuários <span class="obrigatorio">*</span></label>
                <input type="text" name="userLimit" value="<c:out value='${planoEditar.userLimit}' />" />
                <span class="campo-erro" data-erro-de="userLimit">
                    <c:out value="${fieldErrors.userLimit}" />
                </span>
            </div>

            <div class="modal-rodape campo-completo">
                <a href="${pageContext.request.contextPath}/planos-administrativos" class="btn btn-secundario">Cancelar</a>
                <button type="submit" class="btn btn-primario">Salvar alterações</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal: Detalhes do plano -->
<div class="modal-overlay ${not empty planoVer ? 'aberto' : ''}" id="modal-plano-ver">
    <div class="modal">
        <div class="modal-cabecalho">
            <h3 class="modal-titulo">Detalhes do plano de assinatura</h3>
            <a href="${pageContext.request.contextPath}/planos-administrativos" class="modal-fechar">&times;</a>
        </div>
        <p class="modal-subtitulo">Consulte os dados completos e o histórico do cadastro.</p>

        <div class="detalhes-grid">
            <div class="detalhe">
                <div class="detalhe-label">Código</div>
                <div class="detalhe-valor">PLN-<c:out value="${planoVer.planId}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Nome</div>
                <div class="detalhe-valor"><c:out value="${planoVer.name}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Descrição</div>
                <div class="detalhe-valor"><c:out value="${planoVer.description}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Preço</div>
                <div class="detalhe-valor">
                    R$ <fmt:formatNumber value="${planoVer.price}" type="number"
                                         minFractionDigits="2" maxFractionDigits="2" />
                </div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Limite de lojas</div>
                <div class="detalhe-valor"><c:out value="${planoVer.storeLimit}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Limite de usuários</div>
                <div class="detalhe-valor"><c:out value="${planoVer.userLimit}" /></div>
            </div>
            <div class="detalhe-item">
                <div class="detalhe-label">Empresas vinculadas</div>
                <div class="detalhe-valor">
                    <c:out value="${planoVer.companyCount}" />
                </div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Situação</div>
                <div class="detalhe-valor">
                    <c:choose>
                        <c:when test="${planoVer.active}">Ativo</c:when>
                        <c:otherwise>Inativo</c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Data de criação</div>
                <div class="detalhe-valor">
                    <c:choose>
                        <c:when test="${not empty planoVer.createdAt}">
                            <c:out value="${planoVer.createdAtFormatted}" />
                        </c:when>
                        <c:otherwise>—</c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Última atualização</div>
                <div class="detalhe-valor">
                    <c:choose>
                        <c:when test="${not empty planoVer.updatedAt}">
                            <c:out value="${planoVer.updatedAtFormatted}" />
                        </c:when>
                        <c:otherwise>Não atualizado</c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Data de exclusão</div>
                <div class="detalhe-valor">
                    <c:choose>
                        <c:when test="${not empty planoVer.deletedAt}">
                            <c:out value="${planoVer.deletedAtFormatted}" />
                        </c:when>
                        <c:otherwise>Não excluído</c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div class="modal-rodape">
            <a href="${pageContext.request.contextPath}/planos-administrativos" class="btn btn-secundario">Fechar</a>
        </div>
    </div>
</div>

<!-- Modal: Confirmar exclusão -->
<div class="modal-overlay ${not empty planoExcluir ? 'aberto' : ''}" id="modal-plano-excluir">
    <div class="modal modal-pequeno">
        <h3 class="confirmacao-titulo">Tem certeza que deseja excluir?</h3>
        <p class="confirmacao-texto">
            O plano <strong>PLN-<c:out value="${planoExcluir.planId}" /> &mdash; <c:out value="${planoExcluir.name}" /></strong>
            será removido da listagem.
        </p>

        <form action="${pageContext.request.contextPath}/planos-administrativos" method="post">
            <input type="hidden" name="acao" value="excluir" />
            <input type="hidden" name="id" value="${planoExcluir.planId}" />
            <div class="modal-rodape">
                <a href="${pageContext.request.contextPath}/planos-administrativos" class="btn btn-secundario">Cancelar</a>
                <button type="submit" class="btn btn-perigo">Excluir plano</button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/crud.js"></script>
<script data-profile-only src="${pageContext.request.contextPath}/assets/js/crud-ux.js"></script>
</body>
</html>