<%--
  Página de gerenciamento de lojas.
  Recebe do LojaServlet (só quando acao=criar ou acao=editar):
    - empresasDisponiveis (lista de Empresa, pra preencher o select)
    - enderecosDisponiveis (lista de Endereco, pra preencher o select)

  Recebe do LojaServlet (só quando acao=editar):
    - lojaEditar (Loja)

  Recebe do LojaServlet (só quando acao=ver):
    - lojaVer (Loja)

  Recebe do LojaServlet (só quando acao=excluir):
    - lojaExcluir (Loja)
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Mottainai - Lojas</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/crud.css" />
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/icons/loja.svg" type="image/x-icon" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/crud-layout.css" />
</head>
<body data-pagina="lojas">
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
        <h1 class="header-titulo">Controle de lojas</h1>
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
    
        <h2 class="pagina-titulo">Lojas cadastradas</h2>
        <p class="pagina-subtitulo">Gerencie as lojas vinculadas às empresas.</p>

        <form class="toolbar" action="${pageContext.request.contextPath}/lojas" method="get">
            <div class="busca">
                <img class="busca-icone" src="${pageContext.request.contextPath}/assets/icons/search.svg" alt="" />
                <input type="text" name="busca" value="<c:out value='${param.busca}' />"
                       placeholder="Pesquisar por loja, empresa ou CNPJ..." />
            </div>
            <select class="filtro" name="situacao">
                <option value="">Todas as situações</option>
                <option value="ativo"   ${param.situacao == 'ativo'   ? 'selected' : ''}>Ativo</option>
                <option value="inativo" ${param.situacao == 'inativo' ? 'selected' : ''}>Inativo</option>
            </select>
            <button type="submit" class="btn btn-secundario">Pesquisar</button>
            <a href="${pageContext.request.contextPath}/lojas?acao=criar" class="btn btn-primario">
                + Cadastrar loja
            </a>
        </form>

        <div class="tabela-wrap">
            <table class="tabela">
                <thead>
                <tr>
                    <th>Nome da loja</th>
                    <th>Empresa</th>
                    <th>CNPJ</th>
                    <th>E-mail</th>
                    <th>Situação</th>
                    <th>Ações</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty lojas}">
                        <tr>
                            <td colspan="6">
                                <div class="tabela-vazia ativo">Nenhuma loja encontrada.</div>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="loja" items="${lojas}">
                            <tr>
                                <td><c:out value="${loja.name}" /></td>
                                <td><c:out value="${loja.companyName}" /></td>
                                <td><c:out value="${loja.cnpj}" /></td>
                                <td><c:out value="${loja.email}" /></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${loja.active}">
                                            <span class="pill pill-ativo">Ativo</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="pill pill-inativo">Inativo</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="col-acoes">
                                    <a href="${pageContext.request.contextPath}/lojas?acao=ver&id=${loja.storeId}"
                                       class="icone-btn" title="Visualizar">
                                        <img src="${pageContext.request.contextPath}/assets/icons/eye.svg" alt="Visualizar" />
                                    </a>
                                    <a href="${pageContext.request.contextPath}/lojas?acao=editar&id=${loja.storeId}"
                                       class="icone-btn" title="Editar">
                                        <img src="${pageContext.request.contextPath}/assets/icons/edit.svg" alt="Editar" />
                                    </a>
                                    <a href="${pageContext.request.contextPath}/lojas?acao=excluir&id=${loja.storeId}"
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
                            <c:url var="paginacaoUrl1" value="/lojas">
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
                                <c:url var="paginacaoUrl2" value="/lojas">
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
                            <c:url var="paginacaoUrl3" value="/lojas">
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
     MODAIS DE LOJA
     ============================================================ -->

<!-- Modal: Cadastrar loja -->
<div class="modal-overlay ${param.acao == 'criar' || not empty lojaCriar ? 'aberto' : ''}"
     id="modal-loja-criar">
    <div class="modal">
        <div class="modal-cabecalho">
            <h3 class="modal-titulo">Cadastrar loja</h3>
            <a href="${pageContext.request.contextPath}/lojas" class="modal-fechar" aria-label="Fechar">&times;</a>
        </div>
        <p class="modal-subtitulo">Preencha os dados para cadastrar. * Campos obrigatórios.</p>

        <form class="modal-corpo"
              action="${pageContext.request.contextPath}/lojas"
              method="post"
              data-formulario="loja"
              novalidate>
            <input type="hidden" name="acao" value="cadastrar" />

            <div class="campo">
                <label>Nome da loja <span class="obrigatorio">*</span></label>
                <input type="text" name="name" value="<c:out value='${lojaCriar.name}' />" placeholder="Nome da loja" />
                <span class="campo-erro" data-erro-de="name">
                    <c:out value="${fieldErrors.name}" />
                </span>
            </div>
            <div class="campo">
                <label>Empresa <span class="obrigatorio">*</span></label>
                <select name="companyId">
                    <option value="">Selecione</option>

                    <c:forEach var="empresa" items="${empresasDisponiveis}">
                        <option value="${empresa.companyId}"
                            ${lojaCriar.companyId == empresa.companyId
                                    ? 'selected'
                                    : ''}>
                            <c:out value="${empresa.tradeName}" />
                        </option>
                    </c:forEach>
                </select>
                <span class="campo-erro" data-erro-de="companyId">
                    <c:out value="${fieldErrors.companyId}" />
                </span>
            </div>
            <div class="campo">
                <label>CNPJ <span class="obrigatorio">*</span></label>
                <input type="text" name="cnpj" value="<c:out value='${lojaCriar.cnpj}' />" data-mascara="cnpj" />
                <span class="campo-erro" data-erro-de="cnpj">
                     <c:out value="${fieldErrors.cnpj}" />
                </span>
            </div>
            <div class="campo">
                <label>E-mail <span class="obrigatorio">*</span></label>
                <input type="email" name="email" value="<c:out value='${lojaCriar.email}' />" />
                <span class="campo-erro" data-erro-de="email">
                     <c:out value="${fieldErrors.email}" />
                </span>
            </div>
            <div class="campo">
                <label>Telefone <span class="obrigatorio">*</span></label>
                <input type="text" name="phone" value="<c:out value='${lojaCriar.phone}' />" data-mascara="telefone" />
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
                <label>Latitude</label>
                <input type="text" name="latitude" value="<c:out value='${lojaCriar.latitude}' />" />
                <span class="campo-erro" data-erro-de="latitude">
                     <c:out value="${fieldErrors.latitude}" />
                </span>
            </div>
            <div class="campo">
                <label>Longitude</label>
                <input type="text" name="longitude" value="<c:out value='${lojaCriar.longitude}' />" />
                <span class="campo-erro" data-erro-de="longitude">
                     <c:out value="${fieldErrors.longitude}" />
                </span>
            </div>
            <div class="campo campo-completo">
                <label>Endereço <span class="obrigatorio">*</span></label>
                <select name="addressId">
                    <option value="">Selecione</option>

                    <c:forEach var="endereco" items="${enderecosDisponiveis}">
                        <option value="${endereco.addressId}"
                            ${lojaCriar.addressId == endereco.addressId
                                    ? 'selected'
                                    : ''}>
                            <c:out value="${endereco.street}" />,
                            <c:out value="${endereco.number}" />
                        </option>
                    </c:forEach>
                </select>
                <span class="campo-erro" data-erro-de="addressId">
                    <c:out value="${fieldErrors.addressId}" />
                </span>
            </div>

            <div class="modal-rodape campo-completo">
                <a href="${pageContext.request.contextPath}/lojas" class="btn btn-secundario">Cancelar</a>
                <button type="submit" class="btn btn-primario">Cadastrar loja</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal: Editar loja -->
<div class="modal-overlay ${not empty lojaEditar ? 'aberto' : ''}" id="modal-loja-editar">
    <div class="modal">
        <div class="modal-cabecalho">
            <h3 class="modal-titulo">Editar loja</h3>
            <a href="${pageContext.request.contextPath}/lojas" class="modal-fechar" aria-label="Fechar">&times;</a>
        </div>
        <p class="modal-subtitulo">Revise os dados do registro. * Campos obrigatórios.</p>

        <form class="modal-corpo"
              action="${pageContext.request.contextPath}/lojas"
              method="post"
              data-formulario="loja"
              novalidate>
            <input type="hidden" name="acao" value="atualizar" />
            <input type="hidden" name="id" value="${lojaEditar.storeId}" />

            <div class="campo">
                <label>Nome da loja <span class="obrigatorio">*</span></label>
                <input type="text" name="name" value="<c:out value='${lojaEditar.name}' />" />
                <span class="campo-erro" data-erro-de="name">
                     <c:out value="${fieldErrors.name}" />
                </span>
            </div>
            <div class="campo">
                <label>Empresa <span class="obrigatorio">*</span></label>
                <select name="companyId">
                    <option value="">Selecione uma empresa</option>
                    <c:forEach var="emp" items="${empresasDisponiveis}">
                        <option value="${emp.companyId}"
                            ${lojaEditar.companyId == emp.companyId ? 'selected' : ''}>
                            <c:out value="${emp.tradeName}" />
                        </option>
                    </c:forEach>
                </select>
                <span class="campo-erro" data-erro-de="companyId">
                     <c:out value="${fieldErrors.companyId}" />
                </span>
            </div>
            <div class="campo">
                <label>CNPJ <span class="obrigatorio">*</span></label>
                <input type="text" name="cnpj" value="<c:out value='${lojaEditar.cnpj}' />" data-mascara="cnpj" />
                <span class="campo-erro" data-erro-de="cnpj">
                    <c:out value="${fieldErrors.cnpj}" />
                </span>
            </div>
            <div class="campo">
                <label>E-mail <span class="obrigatorio">*</span></label>
                <input type="text" name="email" value="<c:out value='${lojaEditar.email}' />" />
                <span class="campo-erro" data-erro-de="email">
                    <c:out value="${fieldErrors.email}" />
                </span>
            </div>
            <div class="campo">
                <label>Telefone <span class="obrigatorio">*</span></label>
                <input type="text" name="phone" value="<c:out value='${lojaEditar.phone}' />" data-mascara="telefone" />
                <span class="campo-erro" data-erro-de="phone">
                     <c:out value="${fieldErrors.phone}" />
                </span>
            </div>
            <div class="campo">
                <label>Situação <span class="obrigatorio">*</span></label>
                <select name="active">
                    <option value="true"  ${lojaEditar.active ? 'selected' : ''}>Ativo</option>
                    <option value="false" ${!lojaEditar.active ? 'selected' : ''}>Inativo</option>
                </select>
                <span class="campo-erro" data-erro-de="active">
                     <c:out value="${fieldErrors.active}" />
                </span>
            </div>
            <div class="campo">
                <label>Latitude</label>
                <input type="text" name="latitude" value="<c:out value='${lojaEditar.latitude}' />" />
                <span class="campo-erro" data-erro-de="latitude">
                     <c:out value="${fieldErrors.latitude}" />
                </span>
            </div>
            <div class="campo">
                <label>Longitude</label>
                <input type="text" name="longitude" value="<c:out value='${lojaEditar.longitude}' />" />
                <span class="campo-erro" data-erro-de="longitude">
                     <c:out value="${fieldErrors.longitude}" />
                </span>
            </div>
            <div class="campo campo-completo">
                <label>Endereço <span class="obrigatorio">*</span></label>
                <select name="addressId">
                    <option value="">Selecione um endereço</option>
                    <c:forEach var="end" items="${enderecosDisponiveis}">
                        <option value="${end.addressId}"
                            ${lojaEditar.addressId == end.addressId ? 'selected' : ''}>
                            <c:out value="${end.zipCode}" /> &mdash;
                            <c:out value="${end.street}" />, <c:out value="${end.number}" /> &mdash;
                            <c:out value="${end.city}" />
                        </option>
                    </c:forEach>
                </select>
                <span class="campo-erro" data-erro-de="addressId">
                    <c:out value="${fieldErrors.addressId}" />
                </span>
            </div>

            <div class="modal-rodape campo-completo">
                <a href="${pageContext.request.contextPath}/lojas" class="btn btn-secundario">Cancelar</a>
                <button type="submit" class="btn btn-primario">Salvar alterações</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal: Detalhes da loja -->
<div class="modal-overlay ${not empty lojaVer ? 'aberto' : ''}" id="modal-loja-ver">
    <div class="modal">
        <div class="modal-cabecalho">
            <h3 class="modal-titulo">Detalhes da loja</h3>
            <a href="${pageContext.request.contextPath}/lojas" class="modal-fechar" aria-label="Fechar">&times;</a>
        </div>
        <p class="modal-subtitulo">Consulte os dados completos e o histórico do cadastro.</p>

        <div class="detalhes-grid">
            <div class="detalhe">
                <div class="detalhe-label">Código</div>
                <div class="detalhe-valor">LOJ-<c:out value="${lojaVer.storeId}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Nome da loja</div>
                <div class="detalhe-valor"><c:out value="${lojaVer.name}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Empresa</div>
                <div class="detalhe-valor"><c:out value="${lojaVer.companyName}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">CNPJ</div>
                <div class="detalhe-valor"><c:out value="${lojaVer.cnpj}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">E-mail</div>
                <div class="detalhe-valor"><c:out value="${lojaVer.email}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Telefone</div>
                <div class="detalhe-valor"><c:out value="${lojaVer.phone}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Situação</div>
                <div class="detalhe-valor">
                    <c:choose>
                        <c:when test="${lojaVer.active}">Ativo</c:when>
                        <c:otherwise>Inativo</c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">CEP</div>
                <div class="detalhe-valor"><c:out value="${lojaVer.addressZipCode}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Endereço</div>
                <div class="detalhe-valor">
                    <c:out value="${lojaVer.addressStreet}" />, <c:out value="${lojaVer.addressNumber}" />
                    &mdash; <c:out value="${lojaVer.addressNeighborhood}" />
                </div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Cidade / UF</div>
                <div class="detalhe-valor">
                    <c:out value="${lojaVer.addressCity}" /> / <c:out value="${lojaVer.addressState}" />
                </div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Data de criação</div>
                <div class="detalhe-valor">
                    <c:choose>
                        <c:when test="${not empty lojaVer.createdAt}">
                            <c:out value="${lojaVer.createdAtFormatted}" />
                        </c:when>
                        <c:otherwise>—</c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Data de exclusão</div>
                <div class="detalhe-valor">
                    <c:choose>
                        <c:when test="${not empty lojaVer.deletedAt}">
                            <c:out value="${lojaVer.deletedAtFormatted}" />
                        </c:when>
                        <c:otherwise>Não excluído</c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div class="modal-rodape">
            <a href="${pageContext.request.contextPath}/lojas" class="btn btn-secundario">Fechar</a>
        </div>
    </div>
</div>

<!-- Modal: Confirmar exclusão -->
<div class="modal-overlay ${not empty lojaExcluir ? 'aberto' : ''}" id="modal-loja-excluir">
    <div class="modal modal-pequeno">
        <a href="${pageContext.request.contextPath}/lojas" class="modal-fechar" aria-label="Fechar">&times;</a>
        <h3 class="confirmacao-titulo">Tem certeza que deseja excluir?</h3>
        <p class="confirmacao-texto">
            A loja <strong>LOJ-<c:out value="${lojaExcluir.storeId}" /> &mdash; <c:out value="${lojaExcluir.name}" /></strong>
            será removida da listagem.
        </p>

        <form action="${pageContext.request.contextPath}/lojas" method="post">
            <input type="hidden" name="acao" value="excluir" />
            <input type="hidden" name="id" value="${lojaExcluir.storeId}" />
            <div class="modal-rodape">
                <a href="${pageContext.request.contextPath}/lojas" class="btn btn-secundario">Cancelar</a>
                <button type="submit" class="btn btn-perigo">Excluir loja</button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/crud.js"></script>
<script data-profile-only src="${pageContext.request.contextPath}/assets/js/crud-ux.js"></script>
</body>
</html>