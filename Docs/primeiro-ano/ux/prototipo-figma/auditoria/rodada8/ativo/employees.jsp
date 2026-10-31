<%--
  Página de gerenciamento de funcionários.

  Recebe do FuncionarioServlet (listagem normal):
    - funcionarios (lista de Funcionario)
    - paginaAtual, totalPaginas

  Recebe do FuncionarioServlet (só quando acao=criar ou acao=editar):
    - lojasDisponiveis (lista de Loja)
    - cargosDisponiveis (lista de Cargo)

  Recebe do FuncionarioServlet (só quando acao=editar):
    - funcionarioEditar (Funcionario)

  Recebe do FuncionarioServlet (só quando acao=ver):
    - funcionarioVer (Funcionario)

  Recebe do FuncionarioServlet (só quando acao=excluir):
    - funcionarioExcluir (Funcionario)
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Mottainai - Funcionários</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/crud.css" />
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/icons/cracha.svg" type="image/x-icon" />
</head>
<body data-pagina="funcionarios">
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
        <h1 class="header-titulo">Controle de funcionários</h1>
        <div class="header-usuario">
            <span class="header-nome">Fernando</span>
            <span class="header-avatar">
        <img src="${pageContext.request.contextPath}/assets/icons/user.svg" alt="Usuário" />
      </span>
        </div>
    </header>

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
    <main class="main">
        <h2 class="pagina-titulo">Funcionários cadastrados</h2>
        <p class="pagina-subtitulo">Gerencie os funcionários vinculados às lojas.</p>

        <form class="toolbar" action="${pageContext.request.contextPath}/funcionarios" method="get">
            <div class="busca">
                <img class="busca-icone" src="${pageContext.request.contextPath}/assets/icons/search.svg" alt="" />
                <input type="text" name="busca" value="<c:out value='${param.busca}' />"
                       placeholder="Pesquisar por nome, loja ou cargo..." />
            </div>
            <select class="filtro" name="situacao">
                <option value="">Todas as situações</option>
                <option value="ativo"   ${param.situacao == 'ativo'   ? 'selected' : ''}>Ativo</option>
                <option value="inativo" ${param.situacao == 'inativo' ? 'selected' : ''}>Inativo</option>
            </select>
            <button type="submit" class="btn btn-secundario">Pesquisar</button>
            <a href="${pageContext.request.contextPath}/funcionarios?acao=criar" class="btn btn-primario">
                + Cadastrar funcionário
            </a>
        </form>

        <div class="tabela-wrap">
            <table class="tabela">
                <thead>
                <tr>
                    <th>Nome</th>
                    <th>Loja</th>
                    <th>Cargo</th>
                    <th>E-mail</th>
                    <th>Telefone</th>
                    <th>Situação</th>
                    <th>Ações</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty funcionarios}">
                        <tr>
                            <td colspan="7">
                                <div class="tabela-vazia ativo">Nenhum funcionário encontrado.</div>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="func" items="${funcionarios}">
                            <tr>
                                <td><c:out value="${func.name}" /></td>
                                <td><c:out value="${func.storeName}" /></td>
                                <td><c:out value="${func.roleName}" /></td>
                                <td><c:out value="${func.email}" /></td>
                                <td><c:out value="${func.phone}" /></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${func.active}">
                                            <span class="pill pill-ativo">Ativo</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="pill pill-inativo">Inativo</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="col-acoes">
                                    <a href="${pageContext.request.contextPath}/funcionarios?acao=ver&id=${func.employeeId}"
                                       class="icone-btn" title="Visualizar">
                                        <img src="${pageContext.request.contextPath}/assets/icons/eye.svg" alt="Visualizar" />
                                    </a>
                                    <a href="${pageContext.request.contextPath}/funcionarios?acao=editar&id=${func.employeeId}"
                                       class="icone-btn" title="Editar">
                                        <img src="${pageContext.request.contextPath}/assets/icons/edit.svg" alt="Editar" />
                                    </a>
                                    <a href="${pageContext.request.contextPath}/funcionarios?acao=excluir&id=${func.employeeId}"
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
                            <a href="${pageContext.request.contextPath}/funcionarios?pagina=${paginaAtual - 1}&busca=${param.busca}&situacao=${param.situacao}"
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
                                <a href="${pageContext.request.contextPath}/funcionarios?pagina=${pag}&busca=${param.busca}&situacao=${param.situacao}"
                                   class="paginacao-btn">${pag}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <c:choose>
                        <c:when test="${paginaAtual < totalPaginas}">
                            <a href="${pageContext.request.contextPath}/funcionarios?pagina=${paginaAtual + 1}&busca=${param.busca}&situacao=${param.situacao}"
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
     MODAIS DE FUNCIONÁRIO
     ============================================================ -->

<!-- Modal: Cadastrar funcionário -->
<div class="modal-overlay ${param.acao == 'criar' || not empty funcionarioCriar ? 'aberto' : ''}"
     id="modal-funcionario-criar">
    <div class="modal">
        <div class="modal-cabecalho">
            <h3 class="modal-titulo">Cadastrar funcionário</h3>
            <a href="${pageContext.request.contextPath}/funcionarios" class="modal-fechar">&times;</a>
        </div>
        <p class="modal-subtitulo">Preencha os dados para cadastrar. * Campos obrigatórios.</p>

        <form class="modal-corpo"
              action="${pageContext.request.contextPath}/funcionarios"
              method="post"
              data-formulario="funcionario"
              novalidate>
            <input type="hidden" name="acao" value="cadastrar" />

            <div class="campo campo-completo">
                <label>Nome <span class="obrigatorio">*</span></label>
                <input type="text" name="name" value="<c:out value='${funcionarioCriar.name}' />" placeholder="Ex.: João da Silva" />
                <span class="campo-erro" data-erro-de="name">
                    <c:out value="${fieldErrors.name}" />
                </span>
            </div>
            <div class="campo">
                <label>CPF <span class="obrigatorio">*</span></label>
                <input type="text" name="cpf" value="<c:out value='${funcionarioCriar.cpf}' />" placeholder="000.000.000-00" data-mascara="cpf" />
                <span class="campo-erro" data-erro-de="cpf">
                    <c:out value="${fieldErrors.cpf}" />
                </span>
            </div>
            <div class="campo">
                <label>Telefone <span class="obrigatorio">*</span></label>
                <input type="text" name="phone" value="<c:out value='${funcionarioCriar.phone}' />" placeholder="(00) 00000-0000" data-mascara="telefone" />
                <span class="campo-erro" data-erro-de="phone">
                    <c:out value="${fieldErrors.phone}" />
                </span>
            </div>
            <div class="campo campo-completo">
                <label>E-mail <span class="obrigatorio">*</span></label>
                <input type="email" name="email" value="<c:out value='${funcionarioCriar.email}' />" placeholder="Ex.: funcionario@empresa.com.br" />
                <span class="campo-erro" data-erro-de="email">
                    <c:out value="${fieldErrors.email}" />
                </span>
            </div>
            <div class="campo">
                <label>Loja <span class="obrigatorio">*</span></label>
                <select name="storeId">
                    <option value="">Selecione a loja</option>
                    <c:forEach var="loja" items="${lojasDisponiveis}">
                        <option value="${loja.storeId}"
                            ${funcionarioCriar.storeId == loja.storeId
                                    ? 'selected'
                                    : ''}>
                            <c:out value="${loja.name}" />
                        </option>
                    </c:forEach>
                </select>
                <span class="campo-erro" data-erro-de="storeId">
                    <c:out value="${fieldErrors.storeId}" />
                </span>
            </div>
            <div class="campo">
                <label>Cargo <span class="obrigatorio">*</span></label>
                <select name="roleId">
                    <option value="">Selecione o cargo</option>
                    <c:forEach var="cargo" items="${cargosDisponiveis}">
                        <option value="${cargo.roleId}"
                            ${funcionarioCriar.roleId == cargo.roleId
                                    ? 'selected'
                                    : ''}>
                            <c:out value="${cargo.name}" />
                        </option>
                    </c:forEach>
                </select>
                <span class="campo-erro" data-erro-de="roleId">
                    <c:out value="${fieldErrors.roleId}" />
                </span>
            </div>
            <div class="campo">
                <label>Data de admissão <span class="obrigatorio">*</span></label>
                <input type="date" name="hireDate" value="<c:out value='${funcionarioCriar.hireDate}' />" />
                <span class="campo-erro" data-erro-de="hireDate">
                    <c:out value="${fieldErrors.hireDate}" />
                </span>
            </div>
            <div class="campo">
                <label>Situação <span class="obrigatorio">*</span></label>
                <select name="active">
                    <option value="">Selecione</option>

                    <option value="true"
                    ${funcionarioCriar.active == true
                            ? 'selected'
                            : ''}>
                        Ativo
                    </option>

                    <option value="false"
                    ${funcionarioCriar.active == false
                            ? 'selected'
                            : ''}>
                        Inativo
                    </option>
                </select>
                <span class="campo-erro" data-erro-de="active">
                    <c:out value="${fieldErrors.active}" />
                </span>
            </div>

            <div class="modal-rodape campo-completo">
                <a href="${pageContext.request.contextPath}/funcionarios" class="btn btn-secundario">Cancelar</a>
                <button type="submit" class="btn btn-primario">Cadastrar funcionário</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal: Editar funcionário -->
<div class="modal-overlay ${not empty funcionarioEditar ? 'aberto' : ''}" id="modal-funcionario-editar">
    <div class="modal">
        <div class="modal-cabecalho">
            <h3 class="modal-titulo">Editar funcionário</h3>
            <a href="${pageContext.request.contextPath}/funcionarios" class="modal-fechar">&times;</a>
        </div>
        <p class="modal-subtitulo">Revise os dados do registro. * Campos obrigatórios.</p>

        <form class="modal-corpo"
              action="${pageContext.request.contextPath}/funcionarios"
              method="post"
              data-formulario="funcionario"
              novalidate>
            <input type="hidden" name="acao" value="atualizar" />
            <input type="hidden" name="id" value="${funcionarioEditar.employeeId}" />

            <div class="campo campo-completo">
                <label>Nome <span class="obrigatorio">*</span></label>
                <input type="text" name="name" value="<c:out value='${funcionarioEditar.name}' />" />
                <span class="campo-erro" data-erro-de="name">
                    <c:out value="${fieldErrors.name}" />
                </span>
            </div>
            <div class="campo">
                <label>CPF <span class="obrigatorio">*</span></label>
                <input type="text" name="cpf" value="<c:out value='${funcionarioEditar.cpf}' />" data-mascara="cpf" readonly />
                <span class="campo-erro" data-erro-de="cpf">
                    <c:out value="${fieldErrors.cpf}" />
                </span>
            </div>
            <div class="campo">
                <label>Telefone <span class="obrigatorio">*</span></label>
                <input type="text" name="phone" value="<c:out value='${funcionarioEditar.phone}' />" data-mascara="telefone" />
                <span class="campo-erro" data-erro-de="phone">
                    <c:out value="${fieldErrors.phone}" />
                </span>
            </div>
            <div class="campo campo-completo">
                <label>E-mail <span class="obrigatorio">*</span></label>
                <input type="email" name="email" value="<c:out value='${funcionarioEditar.email}' />" />
                <span class="campo-erro" data-erro-de="email">
                    <c:out value="${fieldErrors.email}" />
                </span>
            </div>
            <div class="campo">
                <label>Loja <span class="obrigatorio">*</span></label>
                <select name="storeId">
                    <option value="">Selecione a loja</option>
                    <c:forEach var="loja" items="${lojasDisponiveis}">
                        <option value="${loja.storeId}"
                            ${funcionarioEditar.storeId == loja.storeId ? 'selected' : ''}>
                            <c:out value="${loja.name}" />
                        </option>
                    </c:forEach>
                </select>
                <span class="campo-erro" data-erro-de="storeId">
                    <c:out value="${fieldErrors.storeId}" />
                </span>
            </div>
            <div class="campo">
                <label>Cargo <span class="obrigatorio">*</span></label>
                <select name="roleId">
                    <option value="">Selecione o cargo</option>
                    <c:forEach var="cargo" items="${cargosDisponiveis}">
                        <option value="${cargo.roleId}"
                            ${funcionarioEditar.roleId == cargo.roleId ? 'selected' : ''}>
                            <c:out value="${cargo.name}" />
                        </option>
                    </c:forEach>
                </select>
                <span class="campo-erro" data-erro-de="roleId">
                    <c:out value="${fieldErrors.roleId}" />
                </span>
            </div>
            <div class="campo">
                <label>Data de admissão <span class="obrigatorio">*</span></label>
                <input type="date" name="hireDate"
                       value="<c:out value='${funcionarioEditar.hireDate}' />" />
                <span class="campo-erro" data-erro-de="hireDate">
                    <c:out value="${fieldErrors.hireDate}" />
                </span>
            </div>
            <div class="campo">
                <label>Situação <span class="obrigatorio">*</span></label>
                <select name="active">
                    <option value="true"  ${funcionarioEditar.active ? 'selected' : ''}>Ativo</option>
                    <option value="false" ${!funcionarioEditar.active ? 'selected' : ''}>Inativo</option>
                </select>
                <span class="campo-erro" data-erro-de="active">
                    <c:out value="${fieldErrors.active}" />
                </span>
            </div>

            <div class="modal-rodape campo-completo">
                <a href="${pageContext.request.contextPath}/funcionarios" class="btn btn-secundario">Cancelar</a>
                <button type="submit" class="btn btn-primario">Salvar alterações</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal: Detalhes do funcionário -->
<div class="modal-overlay ${not empty funcionarioVer ? 'aberto' : ''}" id="modal-funcionario-ver">
    <div class="modal">
        <div class="modal-cabecalho">
            <h3 class="modal-titulo">Detalhes de funcionário</h3>
            <a href="${pageContext.request.contextPath}/funcionarios" class="modal-fechar">&times;</a>
        </div>
        <p class="modal-subtitulo">Consulte os dados completos e o histórico do cadastro.</p>

        <div class="detalhes-grid">
            <div class="detalhe">
                <div class="detalhe-label">Código</div>
                <div class="detalhe-valor">FUN-<c:out value="${funcionarioVer.employeeId}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Nome</div>
                <div class="detalhe-valor"><c:out value="${funcionarioVer.name}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">CPF</div>
                <div class="detalhe-valor"><c:out value="${funcionarioVer.cpf}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">E-mail</div>
                <div class="detalhe-valor"><c:out value="${funcionarioVer.email}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Telefone</div>
                <div class="detalhe-valor"><c:out value="${funcionarioVer.phone}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Loja</div>
                <div class="detalhe-valor"><c:out value="${funcionarioVer.storeName}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Cargo</div>
                <div class="detalhe-valor"><c:out value="${funcionarioVer.roleName}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Data de admissão</div>
                <div class="detalhe-valor">
                    <c:choose>
                        <c:when test="${not empty funcionarioVer.hireDate}">
                            <c:out value="${funcionarioVer.hireDateFormatted}" />
                        </c:when>
                        <c:otherwise>—</c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Situação</div>
                <div class="detalhe-valor">
                    <c:choose>
                        <c:when test="${funcionarioVer.active}">Ativo</c:when>
                        <c:otherwise>Inativo</c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Data de criação</div>
                <div class="detalhe-valor">
                    <c:choose>
                        <c:when test="${not empty funcionarioVer.createdAt}">
                            <c:out value="${funcionarioVer.createdAtFormatted}" />
                        </c:when>
                        <c:otherwise>—</c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Data de exclusão</div>
                <div class="detalhe-valor">
                    <c:choose>
                        <c:when test="${not empty funcionarioVer.deletedAt}">
                            <c:out value="${funcionarioVer.deletedAtFormatted}" />
                        </c:when>
                        <c:otherwise>Não excluído</c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div class="modal-rodape">
            <a href="${pageContext.request.contextPath}/funcionarios" class="btn btn-secundario">Fechar</a>
        </div>
    </div>
</div>

<!-- Modal: Confirmar exclusão -->
<div class="modal-overlay ${not empty funcionarioExcluir ? 'aberto' : ''}" id="modal-funcionario-excluir">
    <div class="modal modal-pequeno">
        <h3 class="confirmacao-titulo">Tem certeza que deseja excluir?</h3>
        <p class="confirmacao-texto">
            O funcionário <strong>FUN-<c:out value="${funcionarioExcluir.employeeId}" /> &mdash; <c:out value="${funcionarioExcluir.name}" /></strong>
            será removido da listagem.
        </p>

        <form action="${pageContext.request.contextPath}/funcionarios" method="post">
            <input type="hidden" name="acao" value="excluir" />
            <input type="hidden" name="id" value="${funcionarioExcluir.employeeId}" />
            <div class="modal-rodape">
                <a href="${pageContext.request.contextPath}/funcionarios" class="btn btn-secundario">Cancelar</a>
                <button type="submit" class="btn btn-perigo">Excluir funcionário</button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/crud.js"></script>
</body>
</html>