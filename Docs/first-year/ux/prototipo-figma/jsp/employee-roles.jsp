<%--
  Página de gerenciamento de cargos.

  Recebe do CargoServlet (listagem normal):
    - cargos (lista de Cargo)
    - paginaAtual, totalPaginas

  Recebe do CargoServlet (só quando acao=editar):
    - cargoEditar (Cargo)

  Recebe do CargoServlet (só quando acao=ver):
    - cargoVer (Cargo)

  Recebe do CargoServlet (só quando acao=excluir):
    - cargoExcluir (Cargo)
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Mottainai - Cargos</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/prototipo-figma/css/crud.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/prototipo-figma/css/fontes.css">
<link rel="shortcut icon" href="${pageContext.request.contextPath}/prototipo-figma/assets/img/favicon.ico" type="image/x-icon">
<link rel="stylesheet" href="${pageContext.request.contextPath}/prototipo-figma/css/crud-ux.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/prototipo-figma/css/crud-layout.css" />
</head>
<body data-pagina="cargos">
<div class="app">

    <!-- ===================== SIDEBAR ===================== -->
    <aside class="sidebar">
        <a href="${pageContext.request.contextPath}/inicio" class="sidebar-logo">
            <img src="${pageContext.request.contextPath}/prototipo-figma/assets/icons/logo-administrativo.svg" alt="Mottainai" />
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
        <h1 class="header-titulo">Controle de cargos</h1>
        <div class="perfil-administrativo">
            <button type="button" class="header-usuario perfil-trigger" aria-expanded="false" aria-controls="perfil-popup">
                <span class="header-nome">Administrador</span>
                <span class="header-avatar"><img src="${pageContext.request.contextPath}/prototipo-figma/assets/icons/user.svg" alt="" /></span>
            </button>
            <div class="perfil-popup" id="perfil-popup" hidden aria-labelledby="perfil-titulo">
                <strong class="perfil-titulo" id="perfil-titulo">Minha conta</strong>
                <p class="perfil-subtitulo">Informações do perfil</p>
                <div class="perfil-avatar"><img src="${pageContext.request.contextPath}/prototipo-figma/assets/icons/perfil-usuario-figma.svg" alt="" /></div>
                <p class="perfil-email"><c:out value="${sessionScope.administrationEmail}" /></p>
                <span class="perfil-cargo">Administrador do sistema</span>
                <form action="${pageContext.request.contextPath}/logout" method="post"><button type="submit" class="perfil-sair"><img src="${pageContext.request.contextPath}/prototipo-figma/assets/icons/logout.svg" alt="" />Sair da conta</button></form>
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
    
        <h2 class="pagina-titulo">Cargos cadastrados</h2>
        <p class="pagina-subtitulo">Gerencie os cargos e os níveis de permissão do sistema.</p>

        <form class="toolbar" action="${pageContext.request.contextPath}/cargos" method="get">
            <div class="busca">
                <img class="busca-icone" src="${pageContext.request.contextPath}/prototipo-figma/assets/icons/search.svg" alt="" />
                <input type="text" name="busca" value="<c:out value='${param.busca}' />"
                       placeholder="Pesquisar por nome ou descrição..." />
            </div>
            <button type="submit" class="btn btn-secundario btn-pesquisar">Pesquisar</button>
            <select class="filtro" name="situacao">
                <option value="">Todas as situações</option>
                <option value="ativo"   ${param.situacao == 'ativo'   ? 'selected' : ''}>Ativo</option>
                <option value="inativo" ${param.situacao == 'inativo' ? 'selected' : ''}>Inativo</option>
            </select>
            <a href="${pageContext.request.contextPath}/cargos?acao=criar" class="btn btn-primario">
                + Cadastrar cargo
            </a>
        </form>

        <div class="tabela-wrap">
            <table class="tabela">
                <thead>
                <tr>
                    <th>Nome</th>
                    <th>Descrição</th>
                    <th>Nível de permissão</th>
                    <th>Situação</th>
                    <th>Ações</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty cargos}">
                        <tr>
                            <td colspan="5">
                                <div class="tabela-vazia ativo">Nenhum cargo encontrado.</div>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="cargo" items="${cargos}">
                            <tr>
                                <td><c:out value="${cargo.name}" /></td>
                                <td><c:out value="${cargo.description}" /></td>
                                <td><c:out value="${cargo.permissionLevel}" /></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${cargo.active}">
                                            <span class="pill pill-ativo">Ativo</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="pill pill-inativo">Inativo</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="col-acoes">
                                    <a href="${pageContext.request.contextPath}/cargos?acao=ver&id=${cargo.roleId}"
                                       class="icone-btn" title="Visualizar">
                                        <img src="${pageContext.request.contextPath}/prototipo-figma/assets/icons/eye.svg" alt="Visualizar" />
                                    </a>
                                    <a href="${pageContext.request.contextPath}/cargos?acao=editar&id=${cargo.roleId}"
                                       class="icone-btn" title="Editar">
                                        <img src="${pageContext.request.contextPath}/prototipo-figma/assets/icons/edit.svg" alt="Editar" />
                                    </a>
                                    <a href="${pageContext.request.contextPath}/cargos?acao=excluir&id=${cargo.roleId}"
                                       class="icone-btn icone-btn-perigo" title="Excluir">
                                        <img src="${pageContext.request.contextPath}/prototipo-figma/assets/icons/trash.svg" alt="Excluir" />
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
                            <c:url var="paginacaoUrl1" value="/cargos">
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
                                <c:url var="paginacaoUrl2" value="/cargos">
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
                            <c:url var="paginacaoUrl3" value="/cargos">
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
     MODAIS DE CARGO
     ============================================================ -->

<!-- Modal: Cadastrar cargo -->
<div class="modal-overlay ${param.acao == 'criar' || not empty cargoCriar ? 'aberto' : ''}"
     id="modal-cargo-criar">
    <div class="modal">
        <div class="modal-cabecalho">
            <h3 class="modal-titulo">Cadastrar cargo</h3>
            <a href="${pageContext.request.contextPath}/cargos" class="modal-fechar" aria-label="Fechar">&times;</a>
        </div>
        <p class="modal-subtitulo">Preencha os dados para cadastrar. * Campos obrigatórios.</p>

        <form class="modal-corpo"
              action="${pageContext.request.contextPath}/cargos"
              method="post"
              data-formulario="cargo"
              novalidate>
            <input type="hidden" name="acao" value="cadastrar" />

            <div class="campo campo-completo">
                <label>Nome do cargo <span class="obrigatorio">*</span></label>
                <input type="text" name="name" placeholder="Ex.: Gerente de Loja" />
                <span class="campo-erro" data-erro-de="name">
                    <c:out value="${fieldErrors.name}" />
                </span>
            </div>
            <div class="campo campo-completo">
                <label>Descrição</label>
                <input type="text" name="description" placeholder="Ex.: Função operacional da loja." />
                <span class="campo-erro" data-erro-de="description">
                    <c:out value="${fieldErrors.description}" />
                </span>
            </div>
            <div class="campo">
                <label>Nível de permissão <span class="obrigatorio">*</span></label>
                <input type="text" name="permissionLevel" placeholder="Ex.: 1" />
                <span class="campo-erro" data-erro-de="permissionLevel">
                    <c:out value="${fieldErrors.permissionLevel}" />
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

            <div class="modal-rodape campo-completo">
                <a href="${pageContext.request.contextPath}/cargos" class="btn btn-secundario">Cancelar</a>
                <button type="submit" class="btn btn-primario">Cadastrar cargo</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal: Editar cargo -->
<div class="modal-overlay ${not empty cargoEditar ? 'aberto' : ''}" id="modal-cargo-editar">
    <div class="modal">
        <div class="modal-cabecalho">
            <h3 class="modal-titulo">Editar cargo</h3>
            <a href="${pageContext.request.contextPath}/cargos" class="modal-fechar" aria-label="Fechar">&times;</a>
        </div>
        <p class="modal-subtitulo">Revise os dados do registro. * Campos obrigatórios.</p>

        <form class="modal-corpo"
              action="${pageContext.request.contextPath}/cargos"
              method="post"
              data-formulario="cargo"
              novalidate>
            <input type="hidden" name="acao" value="atualizar" />
            <input type="hidden" name="id" value="${cargoEditar.roleId}" />

            <div class="campo campo-completo">
                <label>Nome do cargo <span class="obrigatorio">*</span></label>
                <input type="text" name="name" value="<c:out value='${cargoEditar.name}' />" />
                <span class="campo-erro" data-erro-de="name">
                    <c:out value="${fieldErrors.name}" />
                </span>
            </div>
            <div class="campo campo-completo">
                <label>Descrição</label>
                <input type="text" name="description" value="<c:out value='${cargoEditar.description}' />" />
                <span class="campo-erro" data-erro-de="description">
                    <c:out value="${fieldErrors.description}" />
                </span>
            </div>
            <div class="campo">
                <label>Nível de permissão <span class="obrigatorio">*</span></label>
                <input type="text" name="permissionLevel" value="<c:out value='${cargoEditar.permissionLevel}' />" />
                <span class="campo-erro" data-erro-de="permissionLevel">
                    <c:out value="${fieldErrors.permissionLevel}" />
                </span>
            </div>
            <div class="campo">
                <label>Situação <span class="obrigatorio">*</span></label>
                <select name="active">
                    <option value="true"  ${cargoEditar.active ? 'selected' : ''}>Ativo</option>
                    <option value="false" ${!cargoEditar.active ? 'selected' : ''}>Inativo</option>
                </select>
                <span class="campo-erro" data-erro-de="active">
                    <c:out value="${fieldErrors.active}" />
                </span>
            </div>

            <div class="modal-rodape campo-completo">
                <a href="${pageContext.request.contextPath}/cargos" class="btn btn-secundario">Cancelar</a>
                <button type="submit" class="btn btn-primario">Salvar alterações</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal: Detalhes do cargo -->
<div class="modal-overlay ${not empty cargoVer ? 'aberto' : ''}" id="modal-cargo-ver">
    <div class="modal">
        <div class="modal-cabecalho">
            <h3 class="modal-titulo">Detalhes de cargo</h3>
            <a href="${pageContext.request.contextPath}/cargos" class="modal-fechar" aria-label="Fechar">&times;</a>
        </div>
        <p class="modal-subtitulo">Consulte os dados completos e o histórico do cadastro.</p>

        <div class="detalhes-grid">
            <div class="detalhe">
                <div class="detalhe-label">Código</div>
                <div class="detalhe-valor">CAR-<c:out value="${cargoVer.roleId}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Nome</div>
                <div class="detalhe-valor"><c:out value="${cargoVer.name}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Descrição</div>
                <div class="detalhe-valor"><c:out value="${cargoVer.description}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Nível de permissão</div>
                <div class="detalhe-valor"><c:out value="${cargoVer.permissionLevel}" /></div>
            </div>
            <div class="detalhe-item">
                <div class="detalhe-label">Funcionários vinculados</div>
                <div class="detalhe-valor">
                    <c:out value="${cargoVer.employeeCount}" />
                </div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Situação</div>
                <div class="detalhe-valor">
                    <c:choose>
                        <c:when test="${cargoVer.active}">Ativo</c:when>
                        <c:otherwise>Inativo</c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Data de criação</div>
                <div class="detalhe-valor">
                    <c:choose>
                        <c:when test="${not empty cargoVer.createdAt}">
                            <c:out value="${cargoVer.createdAtFormatted}" />
                        </c:when>
                        <c:otherwise>—</c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Data de exclusão</div>
                <div class="detalhe-valor">
                    <c:choose>
                        <c:when test="${not empty cargoVer.deletedAt}">
                            <c:out value="${cargoVer.deletedAtFormatted}" />
                        </c:when>
                        <c:otherwise>Não excluído</c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div class="modal-rodape">
            <a href="${pageContext.request.contextPath}/cargos" class="btn btn-secundario">Fechar</a>
        </div>
    </div>
</div>

<!-- Modal: Confirmar exclusão -->
<div class="modal-overlay ${not empty cargoExcluir ? 'aberto' : ''}" id="modal-cargo-excluir">
    <div class="modal modal-pequeno">
        <a href="${pageContext.request.contextPath}/cargos" class="modal-fechar" aria-label="Fechar">&times;</a>
        <h3 class="confirmacao-titulo">Tem certeza que deseja excluir?</h3>
        <p class="confirmacao-texto">
            O cargo <strong>CAR-<c:out value="${cargoExcluir.roleId}" /> &mdash; <c:out value="${cargoExcluir.name}" /></strong>
            será removido da listagem.
        </p>

        <form action="${pageContext.request.contextPath}/cargos" method="post">
            <input type="hidden" name="acao" value="excluir" />
            <input type="hidden" name="id" value="${cargoExcluir.roleId}" />
            <div class="modal-rodape">
                <a href="${pageContext.request.contextPath}/cargos" class="btn btn-secundario">Cancelar</a>
                <button type="submit" class="btn btn-perigo">Excluir cargo</button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/prototipo-figma/js/crud.js"></script>
<script src="${pageContext.request.contextPath}/prototipo-figma/js/crud-ux.js"></script>
</body>
</html>