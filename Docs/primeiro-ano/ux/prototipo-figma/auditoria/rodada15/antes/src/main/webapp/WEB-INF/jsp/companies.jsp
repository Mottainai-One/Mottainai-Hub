<%--
  Recebe do EmpresaServlet só quando acao=editar:
    - empresaEditar (Empresa)

  Recebe do EmpresaServlet só quando acao=ver:
    - empresaVer (Empresa)

  Recebe do EmpresaServlet só quando acao=excluir:
    - empresaExcluir (Empresa)
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Mottainai - Empresas</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/crud.css" />
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/icons/empresa.svg" type="image/x-icon" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/crud-layout.css" />
</head>
<body data-pagina="empresas">
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
        <h1 class="header-titulo">Controle de empresas</h1>
        <div class="header-usuario">
            <span class="header-nome">Fernando</span>
            <span class="header-avatar">
        <img src="${pageContext.request.contextPath}/assets/icons/user.svg" alt="Usuário" />
      </span>
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
    
        <h2 class="pagina-titulo">Empresas cadastradas</h2>
        <p class="pagina-subtitulo">Gerencie as empresas registradas no sistema.</p>

        <!-- Toolbar: form GET que envia busca e situação como query string -->
        <form class="toolbar" action="${pageContext.request.contextPath}/empresas" method="get">
            <div class="busca">
                <img class="busca-icone" src="${pageContext.request.contextPath}/assets/icons/search.svg" alt="" />
                <input type="text" name="busca" value="<c:out value='${param.busca}' />"
                       placeholder="Pesquisar por nome, CNPJ ou e-mail..." />
            </div>
            <select class="filtro" name="situacao">
                <option value="">Todas as situações</option>
                <option value="ativo"   ${param.situacao == 'ativo'   ? 'selected' : ''}>Ativo</option>
                <option value="inativo" ${param.situacao == 'inativo' ? 'selected' : ''}>Inativo</option>
            </select>
            <button type="submit" class="btn btn-secundario">Pesquisar</button>
            <a href="${pageContext.request.contextPath}/empresas?acao=criar" class="btn btn-primario">
                + Cadastrar empresa
            </a>
        </form>

        <div class="tabela-wrap">
            <table class="tabela">
                <thead>
                <tr>
                    <th>Nome fantasia</th>
                    <th>Razão social</th>
                    <th>CNPJ</th>
                    <th>E-mail</th>
                    <th>Telefone</th>
                    <th>Situação</th>
                    <th>Ações</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty empresas}">
                        <tr>
                            <td colspan="7">
                                <div class="tabela-vazia ativo">Nenhuma empresa encontrada.</div>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="emp" items="${empresas}">
                            <tr>
                                <td><c:out value="${emp.tradeName}" /></td>
                                <td><c:out value="${emp.officialName}" /></td>
                                <td><c:out value="${emp.cnpj}" /></td>
                                <td><c:out value="${emp.email}" /></td>
                                <td><c:out value="${emp.phone}" /></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${emp.active}">
                                            <span class="pill pill-ativo">Ativo</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="pill pill-inativo">Inativo</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="col-acoes">
                                    <a href="${pageContext.request.contextPath}/empresas?acao=ver&id=${emp.companyId}"
                                       class="icone-btn" title="Visualizar">
                                        <img src="${pageContext.request.contextPath}/assets/icons/eye.svg" alt="Visualizar" />
                                    </a>
                                    <a href="${pageContext.request.contextPath}/empresas?acao=editar&id=${emp.companyId}"
                                       class="icone-btn" title="Editar">
                                        <img src="${pageContext.request.contextPath}/assets/icons/edit.svg" alt="Editar" />
                                    </a>
                                    <a href="${pageContext.request.contextPath}/empresas?acao=excluir&id=${emp.companyId}"
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
                            <c:url var="paginacaoUrl1" value="/empresas">
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
                                <c:url var="paginacaoUrl2" value="/empresas">
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
                            <c:url var="paginacaoUrl3" value="/empresas">
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
     MODAIS DE EMPRESA
     Cada modal abre se o Servlet setou a variável correspondente.
     ============================================================ -->

<!-- Modal: Cadastrar empresa -->
<div class="modal-overlay ${param.acao == 'criar' || not empty empresaCriar ? 'aberto' : ''}"
     id="modal-empresa-criar">
    <div class="modal">
        <div class="modal-cabecalho">
            <h3 class="modal-titulo">Cadastrar empresa</h3>
            <a href="${pageContext.request.contextPath}/empresas" class="modal-fechar">&times;</a>
        </div>
        <p class="modal-subtitulo">Preencha os dados para cadastrar. * Campos obrigatórios.</p>

        <form class="modal-corpo"
              action="${pageContext.request.contextPath}/empresas"
              method="post"
              data-formulario="empresa"
              novalidate>
            <input type="hidden" name="acao" value="cadastrar" />

            <div class="campo">
                <label>Razão social <span class="obrigatorio">*</span></label>
                <input type="text" name="officialName" value="<c:out value='${empresaCriar.officialName}' />" placeholder="Ex.: Aurora Alimentos Ltda." />
                <span class="campo-erro" data-erro-de="officialName">
                    <c:out value="${fieldErrors.officialName}" />
                </span>
            </div>
            <div class="campo">
                <label>Nome fantasia</label>
                <input type="text" name="tradeName" value="<c:out value='${empresaCriar.tradeName}' />" placeholder="Ex.: Mercado Aurora" />
                <span class="campo-erro" data-erro-de="tradeName">
                    <c:out value="${fieldErrors.tradeName}" />
                </span>
            </div>
            <div class="campo">
                <label>CNPJ <span class="obrigatorio">*</span></label>
                <input type="text" name="cnpj" value="<c:out value='${empresaCriar.cnpj}' />" placeholder="00.000.000/0000-00" data-mascara="cnpj" />
                <span class="campo-erro" data-erro-de="cnpj">
                    <c:out value="${fieldErrors.cnpj}" />
                </span>
            </div>
            <div class="campo">
                <label>E-mail <span class="obrigatorio">*</span></label>
                <input type="text" name="email" value="<c:out value='${empresaCriar.email}' />" placeholder="Ex.: contato@empresa.com.br" />
                <span class="campo-erro" data-erro-de="email">
                    <c:out value="${fieldErrors.email}" />
                </span>
            </div>
            <div class="campo">
                <label>Telefone</label>
                <input type="text" name="phone" value="<c:out value='${empresaCriar.phone}' />" placeholder="(00) 00000-0000" data-mascara="telefone" />
                <span class="campo-erro" data-erro-de="phone">
                    <c:out value="${fieldErrors.phone}" />
                </span>
            </div>
            <div class="campo">
                <label>Situação <span class="obrigatorio">*</span></label>
                <select name="active">
                    <option value="">Selecione</option>
                    <option value="true">Ativo</option>
                    <option value="false">Inativo</option>
                </select>
                <span class="campo-erro" data-erro-de="active">
                    <c:out value="${fieldErrors.active}" />
                </span>
            </div>
            <div class="campo">
                <label>Plano de assinatura <span class="obrigatorio">*</span></label>

                <select name="subscriptionPlanId">
                    <option value="">Selecione um plano</option>

                    <c:forEach var="plano" items="${planosDisponiveis}">
                        <option value="${plano.planId}">
                            <c:out value="${plano.name}" />
                        </option>
                    </c:forEach>
                </select>

                <span class="campo-erro" data-erro-de="subscriptionPlanId">
                    <c:out value="${fieldErrors.subscriptionPlanId}" />
                </span>
            </div>
            <div class="campo">
                <label>Latitude</label>
                <input type="text" name="latitude" value="<c:out value='${empresaCriar.latitude}' />" placeholder="Ex.: -23.550520" />
                <span class="campo-erro" data-erro-de="latitude">
                    <c:out value="${fieldErrors.latitude}" />
                </span>
            </div>
            <div class="campo">
                <label>Longitude</label>
                <input type="text" name="longitude" value="<c:out value='${empresaCriar.longitude}' />" placeholder="Ex.: -46.633308" />
                <span class="campo-erro" data-erro-de="longitude">
                    <c:out value="${fieldErrors.longitude}" />
                </span>
            </div>

            <div class="modal-rodape campo-completo">
                <a href="${pageContext.request.contextPath}/empresas" class="btn btn-secundario">Cancelar</a>
                <button type="submit" class="btn btn-primario">Cadastrar empresa</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal: Editar empresa -->
<div class="modal-overlay ${not empty empresaEditar ? 'aberto' : ''}" id="modal-empresa-editar">
    <div class="modal">
        <div class="modal-cabecalho">
            <h3 class="modal-titulo">Editar empresa</h3>
            <a href="${pageContext.request.contextPath}/empresas" class="modal-fechar">&times;</a>
        </div>
        <p class="modal-subtitulo">Revise os dados do registro. * Campos obrigatórios.</p>

        <form class="modal-corpo"
              action="${pageContext.request.contextPath}/empresas"
              method="post"
              data-formulario="empresa"
              novalidate>
            <input type="hidden" name="acao" value="atualizar" />
            <input type="hidden" name="id" value="${empresaEditar.companyId}" />

            <div class="campo">
                <label>Razão social <span class="obrigatorio">*</span></label>
                <input type="text" name="officialName" value="<c:out value='${empresaEditar.officialName}' />" />
                <span class="campo-erro" data-erro-de="officialName">
                    <c:out value="${fieldErrors.officialName}" />
                </span>
            </div>
            <div class="campo">
                <label>Nome fantasia</label>
                <input type="text" name="tradeName" value="<c:out value='${empresaEditar.tradeName}' />" />
                <span class="campo-erro" data-erro-de="tradeName">
                    <c:out value="${fieldErrors.tradeName}" />
                </span>
            </div>
            <div class="campo">
                <label>CNPJ <span class="obrigatorio">*</span></label>
                <input type="text" name="cnpj" value="<c:out value='${empresaEditar.cnpj}' />" data-mascara="cnpj" />
                <span class="campo-erro" data-erro-de="cnpj">
                    <c:out value="${fieldErrors.cnpj}" />
                </span>
            </div>
            <div class="campo">
                <label>Plano de assinatura <span class="obrigatorio">*</span></label>

                <select name="subscriptionPlanId">

                    <c:forEach var="plano" items="${planosDisponiveis}">
                        <option value="${plano.planId}"
                            ${empresaEditar.subscriptionPlanId == plano.planId
                                    ? 'selected'
                                    : ''}>

                            <c:out value="${plano.name}" />
                        </option>
                    </c:forEach>

                </select>

                <span class="campo-erro" data-erro-de="subscriptionPlanId">
                    <c:out value="${fieldErrors.subscriptionPlanId}" />
                </span>
            </div>
            <div class="campo">
                <label>E-mail <span class="obrigatorio">*</span></label>
                <input type="text" name="email" value="<c:out value='${empresaEditar.email}' />" />
                <span class="campo-erro" data-erro-de="email">
                    <c:out value="${fieldErrors.email}" />
                </span>
            </div>
            <div class="campo">
                <label>Telefone</label>
                <input type="text" name="phone" value="<c:out value='${empresaEditar.phone}' />" data-mascara="telefone" />
                <span class="campo-erro" data-erro-de="phone">
                    <c:out value="${fieldErrors.phone}" />
                </span>
            </div>
            <div class="campo">
                <label>Situação <span class="obrigatorio">*</span></label>
                <select name="active">
                    <option value="true"  ${empresaEditar.active ? 'selected' : ''}>Ativo</option>
                    <option value="false" ${!empresaEditar.active ? 'selected' : ''}>Inativo</option>
                </select>
                <span class="campo-erro" data-erro-de="active">
                    <c:out value="${fieldErrors.active}" />
                </span>
            </div>
            <div class="campo">
                <label>Latitude</label>
                <input type="text" name="latitude" value="<c:out value='${empresaEditar.latitude}' />" />
                <span class="campo-erro" data-erro-de="latitude">
                    <c:out value="${fieldErrors.latitude}" />
                </span>
            </div>
            <div class="campo">
                <label>Longitude</label>
                <input type="text" name="longitude" value="<c:out value='${empresaEditar.longitude}' />" />
                <span class="campo-erro" data-erro-de="longitude">
                    <c:out value="${fieldErrors.longitude}" />
                </span>
            </div>

            <div class="modal-rodape campo-completo">
                <a href="${pageContext.request.contextPath}/empresas" class="btn btn-secundario">Cancelar</a>
                <button type="submit" class="btn btn-primario">Salvar alterações</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal: Detalhes da empresa -->
<div class="modal-overlay ${not empty empresaVer ? 'aberto' : ''}" id="modal-empresa-ver">
    <div class="modal">
        <div class="modal-cabecalho">
            <h3 class="modal-titulo">Detalhes de empresa</h3>
            <a href="${pageContext.request.contextPath}/empresas" class="modal-fechar">&times;</a>
        </div>
        <p class="modal-subtitulo">Consulte os dados completos e o histórico do cadastro.</p>

        <div class="detalhes-grid">
            <div class="detalhe">
                <div class="detalhe-label">Código</div>
                <div class="detalhe-valor">EMP-<c:out value="${empresaVer.companyId}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Razão social</div>
                <div class="detalhe-valor"><c:out value="${empresaVer.officialName}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Nome fantasia</div>
                <div class="detalhe-valor"><c:out value="${empresaVer.tradeName}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">CNPJ</div>
                <div class="detalhe-valor"><c:out value="${empresaVer.cnpj}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">E-mail</div>
                <div class="detalhe-valor"><c:out value="${empresaVer.email}" /></div>
            </div>
            <div class="detalhe-item">
                <div class="detalhe-label">Plano de assinatura</div>
                <div class="detalhe-valor">
                    PLN-<c:out value="${empresaVer.subscriptionPlanId}" />
                    &mdash;
                    <c:out value="${empresaVer.subscriptionPlanName}" />
                </div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Telefone</div>
                <div class="detalhe-valor"><c:out value="${empresaVer.phone}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Situação</div>
                <div class="detalhe-valor">
                    <c:choose>
                        <c:when test="${empresaVer.active}">Ativo</c:when>
                        <c:otherwise>Inativo</c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Latitude</div>
                <div class="detalhe-valor"><c:out value="${empresaVer.latitude}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Longitude</div>
                <div class="detalhe-valor"><c:out value="${empresaVer.longitude}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Data de criação</div>
                <div class="detalhe-valor">
                    <c:choose>
                        <c:when test="${not empty empresaVer.createdAt}">
                            <c:out value="${empresaVer.createdAtFormatted}" />
                        </c:when>
                        <c:otherwise>—</c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Data de exclusão</div>
                <div class="detalhe-valor">
                    <c:choose>
                        <c:when test="${not empty empresaVer.deletedAt}">
                            <c:out value="${empresaVer.deletedAtFormatted}" />
                        </c:when>
                        <c:otherwise>Não excluído</c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div class="modal-rodape">
            <a href="${pageContext.request.contextPath}/empresas" class="btn btn-secundario">Fechar</a>
        </div>
    </div>
</div>

<!-- Modal: Confirmar exclusão -->
<div class="modal-overlay ${not empty empresaExcluir ? 'aberto' : ''}" id="modal-empresa-excluir">
    <div class="modal modal-pequeno">
        <h3 class="confirmacao-titulo">Tem certeza que deseja excluir?</h3>
        <p class="confirmacao-texto">
            A empresa <strong>EMP-<c:out value="${empresaExcluir.companyId}" /> &mdash; <c:out value="${empresaExcluir.tradeName}" /></strong>
            será removida da listagem.
        </p>

        <form action="${pageContext.request.contextPath}/empresas" method="post">
            <input type="hidden" name="acao" value="excluir" />
            <input type="hidden" name="id" value="${empresaExcluir.companyId}" />
            <div class="modal-rodape">
                <a href="${pageContext.request.contextPath}/empresas" class="btn btn-secundario">Cancelar</a>
                <button type="submit" class="btn btn-perigo">Excluir empresa</button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/crud.js"></script>
</body>
</html>