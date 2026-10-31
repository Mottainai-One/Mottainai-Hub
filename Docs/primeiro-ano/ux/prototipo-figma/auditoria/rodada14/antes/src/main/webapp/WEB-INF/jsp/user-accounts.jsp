<%--
  Página de gerenciamento de contas de usuário.

  Recebe do ContaServlet (listagem normal):
    - contas (lista de ContaUsuario)
    - paginaAtual, totalPaginas

  Recebe do ContaServlet (só quando acao=criar ou acao=editar):
    - funcionariosDisponiveis (lista de Funcionario)

  Recebe do ContaServlet (só quando acao=editar):
    - contaEditar (ContaUsuario)

  Recebe do ContaServlet (só quando acao=ver):
    - contaVer (ContaUsuario)

  Recebe do ContaServlet (só quando acao=excluir):
    - contaExcluir (ContaUsuario)
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Mottainai - Contas de usuários</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/crud.css" />
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/icons/user.svg" type="image/x-icon" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/crud-layout.css" />
</head>
<body data-pagina="contas">
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
        <h1 class="header-titulo">Controle de contas de usuários</h1>
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
    
        <h2 class="pagina-titulo">Contas de usuários cadastradas</h2>
        <p class="pagina-subtitulo">Gerencie as contas de acesso vinculadas aos funcionários.</p>

        <form class="toolbar" action="${pageContext.request.contextPath}/contas" method="get">
            <div class="busca">
                <img class="busca-icone" src="${pageContext.request.contextPath}/assets/icons/search.svg" alt="" />
                <input type="text" name="busca" value="<c:out value='${param.busca}' />"
                       placeholder="Pesquisar por e-mail ou funcionário..." />
            </div>
            <select class="filtro" name="situacao">
                <option value="">Todas as situações</option>
                <option value="ativo"   ${param.situacao == 'ativo'   ? 'selected' : ''}>Ativo</option>
                <option value="inativo" ${param.situacao == 'inativo' ? 'selected' : ''}>Inativo</option>
            </select>
            <button type="submit" class="btn btn-secundario">Pesquisar</button>
            <a href="${pageContext.request.contextPath}/contas?acao=criar" class="btn btn-primario">
                + Cadastrar conta
            </a>
        </form>

        <div class="tabela-wrap">
            <table class="tabela">
                <thead>
                <tr>
                    <th>E-mail de acesso</th>
                    <th>Funcionário</th>
                    <th>Último acesso</th>
                    <th>Situação</th>
                    <th>Ações</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty contas}">
                        <tr>
                            <td colspan="5">
                                <div class="tabela-vazia ativo">Nenhuma conta encontrada.</div>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="conta" items="${contas}">
                            <tr>
                                <td><c:out value="${conta.email}" /></td>
                                <td><c:out value="${conta.employeeName}" /></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty conta.lastLogin}">
                                            <c:out value="${conta.lastLoginFormatted}" />
                                        </c:when>
                                        <c:otherwise>Nunca acessou</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${conta.active}">
                                            <span class="pill pill-ativo">Ativo</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="pill pill-inativo">Inativo</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="col-acoes">
                                    <a href="${pageContext.request.contextPath}/contas?acao=ver&id=${conta.userId}"
                                       class="icone-btn" title="Visualizar">
                                        <img src="${pageContext.request.contextPath}/assets/icons/eye.svg" alt="Visualizar" />
                                    </a>
                                    <a href="${pageContext.request.contextPath}/contas?acao=editar&id=${conta.userId}"
                                       class="icone-btn" title="Editar">
                                        <img src="${pageContext.request.contextPath}/assets/icons/edit.svg" alt="Editar" />
                                    </a>
                                    <a href="${pageContext.request.contextPath}/contas?acao=excluir&id=${conta.userId}"
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
                            <c:url var="paginacaoUrl1" value="/contas">
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
                                <c:url var="paginacaoUrl2" value="/contas">
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
                            <c:url var="paginacaoUrl3" value="/contas">
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
     MODAIS DE CONTA DE USUÁRIO
     ============================================================ -->

<!-- Modal: Cadastrar conta -->
<div class="modal-overlay ${param.acao == 'criar' || not empty contaCriar ? 'aberto' : ''}"
     id="modal-conta-criar">
    <div class="modal">
        <div class="modal-cabecalho">
            <h3 class="modal-titulo">Cadastrar conta de usuário</h3>
            <a href="${pageContext.request.contextPath}/contas" class="modal-fechar">&times;</a>
        </div>
        <p class="modal-subtitulo">Preencha os dados para cadastrar. * Campos obrigatórios.</p>

        <form class="modal-corpo"
              action="${pageContext.request.contextPath}/contas"
              method="post"
              data-formulario="conta"
              novalidate>
            <input type="hidden" name="acao" value="cadastrar" />

            <div class="campo campo-completo">
                <label>Funcionário <span class="obrigatorio">*</span></label>
                <select name="employeeId">
                    <option value="">Selecione um funcionário</option>
                    <c:forEach var="func" items="${funcionariosDisponiveis}">
                        <option value="${func.employeeId}">
                            <c:out value="${func.name}" /> &mdash; <c:out value="${func.storeName}" />
                        </option>
                    </c:forEach>
                </select>
                <span class="campo-erro" data-erro-de="employeeId">
                    <c:out value="${fieldErrors.employeeId}" />
                </span>
            </div>
            <div class="campo campo-completo">
                <label>E-mail de acesso <span class="obrigatorio">*</span></label>
                <input type="email" name="email" value="<c:out value='${contaCriar.email}' />" placeholder="Ex.: usuario@empresa.com.br" />
                <span class="campo-erro" data-erro-de="email">
                    <c:out value="${fieldErrors.email}" />
                </span>
            </div>
            <div class="campo">
                <label>Senha <span class="obrigatorio">*</span></label>
                <input type="password" name="password" placeholder="Mínimo de 8 caracteres" />
                <span class="campo-erro" data-erro-de="password">
                    <c:out value="${fieldErrors.password}" />
                </span>
            </div>
            <div class="campo">
                <label>Situação <span class="obrigatorio">*</span></label>
                <select name="active">
                    <option value="">Selecione</option>

                    <option value="true"
                    ${contaCriar.active == true ? 'selected' : ''}>
                        Ativo
                    </option>

                    <option value="false"
                    ${contaCriar.active == false ? 'selected' : ''}>
                        Inativo
                    </option>
                </select>
                <span class="campo-erro" data-erro-de="active">
                    <c:out value="${fieldErrors.active}" />
                </span>
            </div>

            <div class="modal-rodape campo-completo">
                <a href="${pageContext.request.contextPath}/contas" class="btn btn-secundario">Cancelar</a>
                <button type="submit" class="btn btn-primario">Cadastrar conta</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal: Editar conta -->
<div class="modal-overlay ${not empty contaEditar ? 'aberto' : ''}" id="modal-conta-editar">
    <div class="modal">
        <div class="modal-cabecalho">
            <h3 class="modal-titulo">Editar conta de usuário</h3>
            <a href="${pageContext.request.contextPath}/contas" class="modal-fechar">&times;</a>
        </div>
        <p class="modal-subtitulo">Revise os dados do registro. * Campos obrigatórios.</p>

        <form class="modal-corpo"
              action="${pageContext.request.contextPath}/contas"
              method="post"
              data-formulario="conta"
              novalidate>
            <input type="hidden" name="acao" value="atualizar" />
            <input type="hidden" name="id" value="${contaEditar.userId}" />

            <div class="campo campo-completo">
                <label>Funcionário <span class="obrigatorio">*</span></label>
                <select name="employeeId">
                    <option value="">Selecione um funcionário</option>
                    <c:forEach var="func" items="${funcionariosDisponiveis}">
                        <option value="${func.employeeId}"
                            ${contaEditar.employeeId == func.employeeId ? 'selected' : ''}>
                            <c:out value="${func.name}" /> &mdash; <c:out value="${func.storeName}" />
                        </option>
                    </c:forEach>
                </select>
                <span class="campo-erro" data-erro-de="employeeId">
                    <c:out value="${fieldErrors.employeeId}" />
                </span>
            </div>
            <div class="campo campo-completo">
                <label>E-mail de acesso <span class="obrigatorio">*</span></label>
                <input type="email" name="email" value="<c:out value='${contaEditar.email}' />" />
                <span class="campo-erro" data-erro-de="email">
                    <c:out value="${fieldErrors.email}" />
                </span>
            </div>
            <div class="campo">
                <label>Nova senha</label>
                <input type="password" name="password" placeholder="Deixe em branco para manter" />
                <span class="campo-erro" data-erro-de="password">
                    <c:out value="${fieldErrors.password}" />
                </span>
            </div>
            <div class="campo">
                <label>Situação <span class="obrigatorio">*</span></label>
                <select name="active">
                    <option value="true"  ${contaEditar.active ? 'selected' : ''}>Ativo</option>
                    <option value="false" ${!contaEditar.active ? 'selected' : ''}>Inativo</option>
                </select>
                <span class="campo-erro" data-erro-de="active">
                    <c:out value="${fieldErrors.active}" />
                </span>
            </div>

            <div class="modal-rodape campo-completo">
                <a href="${pageContext.request.contextPath}/contas" class="btn btn-secundario">Cancelar</a>
                <button type="submit" class="btn btn-primario">Salvar alterações</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal: Detalhes da conta -->
<div class="modal-overlay ${not empty contaVer ? 'aberto' : ''}" id="modal-conta-ver">
    <div class="modal">
        <div class="modal-cabecalho">
            <h3 class="modal-titulo">Detalhes de conta de usuário</h3>
            <a href="${pageContext.request.contextPath}/contas" class="modal-fechar">&times;</a>
        </div>
        <p class="modal-subtitulo">Consulte os dados completos e o histórico do cadastro.</p>

        <div class="detalhes-grid">
            <div class="detalhe">
                <div class="detalhe-label">Código</div>
                <div class="detalhe-valor">USR-<c:out value="${contaVer.userId}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">E-mail de acesso</div>
                <div class="detalhe-valor"><c:out value="${contaVer.email}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Funcionário</div>
                <div class="detalhe-valor"><c:out value="${contaVer.employeeName}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Loja</div>
                <div class="detalhe-valor"><c:out value="${contaVer.storeName}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Cargo</div>
                <div class="detalhe-valor"><c:out value="${contaVer.roleName}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Situação</div>
                <div class="detalhe-valor">
                    <c:choose>
                        <c:when test="${contaVer.active}">Ativo</c:when>
                        <c:otherwise>Inativo</c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Último acesso</div>
                <div class="detalhe-valor">
                    <c:choose>
                        <c:when test="${not empty contaVer.lastLogin}">
                            <c:out value="${contaVer.lastLoginFormatted}" />
                        </c:when>
                        <c:otherwise>Nunca acessou</c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Data de criação</div>
                <div class="detalhe-valor">
                    <c:choose>
                        <c:when test="${not empty contaVer.createdAt}">
                            <c:out value="${contaVer.createdAtFormatted}" />
                        </c:when>
                        <c:otherwise>—</c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Data de exclusão</div>
                <div class="detalhe-valor">
                    <c:choose>
                        <c:when test="${not empty contaVer.deletedAt}">
                            <c:out value="${contaVer.deletedAtFormatted}" />
                        </c:when>
                        <c:otherwise>Não excluído</c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div class="modal-rodape">
            <a href="${pageContext.request.contextPath}/contas" class="btn btn-secundario">Fechar</a>
        </div>
    </div>
</div>

<!-- Modal: Confirmar exclusão -->
<div class="modal-overlay ${not empty contaExcluir ? 'aberto' : ''}" id="modal-conta-excluir">
    <div class="modal modal-pequeno">
        <h3 class="confirmacao-titulo">Tem certeza que deseja excluir?</h3>
        <p class="confirmacao-texto">
            A conta <strong>USR-<c:out value="${contaExcluir.userId}" /> &mdash; <c:out value="${contaExcluir.email}" /></strong>
            será removida da listagem.
        </p>

        <form action="${pageContext.request.contextPath}/contas" method="post">
            <input type="hidden" name="acao" value="excluir" />
            <input type="hidden" name="id" value="${contaExcluir.userId}" />
            <div class="modal-rodape">
                <a href="${pageContext.request.contextPath}/contas" class="btn btn-secundario">Cancelar</a>
                <button type="submit" class="btn btn-perigo">Excluir conta</button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/crud.js"></script>
</body>
</html>