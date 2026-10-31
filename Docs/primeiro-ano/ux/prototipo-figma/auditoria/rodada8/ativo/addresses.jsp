<%--
  Página de gerenciamento de endereços.

  Recebe do EnderecoServlet (listagem normal):
    - enderecos (lista de Endereco)
    - paginaAtual, totalPaginas

  Recebe do EnderecoServlet (só quando acao=editar):
    - enderecoEditar (Endereco)

  Recebe do EnderecoServlet (só quando acao=ver):
    - enderecoVer (Endereco)

  Recebe do EnderecoServlet (só quando acao=excluir):
    - enderecoExcluir (Endereco)
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Mottainai - Endereços</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/crud.css" />
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/icons/loja_alt.svg" type="image/x-icon" />
</head>
<body data-pagina="enderecos">
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
        <h1 class="header-titulo">Controle de endereços</h1>
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
        <h2 class="pagina-titulo">Endereços cadastrados</h2>
        <p class="pagina-subtitulo">Gerencie os endereços vinculados às lojas.</p>

        <form class="toolbar" action="${pageContext.request.contextPath}/enderecos" method="get">
            <div class="busca">
                <img class="busca-icone" src="${pageContext.request.contextPath}/assets/icons/search.svg" alt="" />
                <input type="text" name="busca" value="<c:out value='${param.busca}' />"
                       placeholder="Pesquisar por CEP, logradouro ou cidade..." />
            </div>
            <button type="submit" class="btn btn-secundario">Pesquisar</button>
            <a href="${pageContext.request.contextPath}/enderecos?acao=criar" class="btn btn-primario">
                + Cadastrar endereço
            </a>
        </form>

        <div class="tabela-wrap">
            <table class="tabela">
                <thead>
                <tr>
                    <th>CEP</th>
                    <th>Logradouro</th>
                    <th>Número</th>
                    <th>Bairro</th>
                    <th>Cidade</th>
                    <th>Estado</th>
                    <th>Ações</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty enderecos}">
                        <tr>
                            <td colspan="7">
                                <div class="tabela-vazia ativo">Nenhum endereço encontrado.</div>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="end" items="${enderecos}">
                            <tr>
                                <td><c:out value="${end.zipCode}" /></td>
                                <td><c:out value="${end.street}" /></td>
                                <td><c:out value="${end.number}" /></td>
                                <td><c:out value="${end.neighborhood}" /></td>
                                <td><c:out value="${end.city}" /></td>
                                <td><c:out value="${end.state}" /></td>
                                <td class="col-acoes">
                                    <a href="${pageContext.request.contextPath}/enderecos?acao=ver&id=${end.addressId}"
                                       class="icone-btn" title="Visualizar">
                                        <img src="${pageContext.request.contextPath}/assets/icons/eye.svg" alt="Visualizar" />
                                    </a>
                                    <a href="${pageContext.request.contextPath}/enderecos?acao=editar&id=${end.addressId}"
                                       class="icone-btn" title="Editar">
                                        <img src="${pageContext.request.contextPath}/assets/icons/edit.svg" alt="Editar" />
                                    </a>
                                    <a href="${pageContext.request.contextPath}/enderecos?acao=excluir&id=${end.addressId}"
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
                            <a href="${pageContext.request.contextPath}/enderecos?pagina=${paginaAtual - 1}&busca=${param.busca}"
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
                                <a href="${pageContext.request.contextPath}/enderecos?pagina=${pag}&busca=${param.busca}"
                                   class="paginacao-btn">${pag}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <c:choose>
                        <c:when test="${paginaAtual < totalPaginas}">
                            <a href="${pageContext.request.contextPath}/enderecos?pagina=${paginaAtual + 1}&busca=${param.busca}"
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
     MODAIS DE ENDEREÇO
     ============================================================ -->

<!-- Modal: Cadastrar endereço -->
<div class="modal-overlay ${param.acao == 'criar' || not empty enderecoCriar ? 'aberto' : ''}"
     id="modal-endereco-criar">
    <div class="modal">
        <div class="modal-cabecalho">
            <h3 class="modal-titulo">Cadastrar endereço</h3>
            <a href="${pageContext.request.contextPath}/enderecos" class="modal-fechar">&times;</a>
        </div>
        <p class="modal-subtitulo">Preencha os dados para cadastrar. * Campos obrigatórios.</p>

        <form class="modal-corpo"
              action="${pageContext.request.contextPath}/enderecos"
              method="post"
              data-formulario="endereco"
              novalidate>
            <input type="hidden" name="acao" value="cadastrar" />

            <div class="campo">
                <label>CEP <span class="obrigatorio">*</span></label>
                <input type="text" name="zipCode" placeholder="00000-000" data-mascara="cep" />
                <span class="campo-erro" data-erro-de="zipCode">
                    <c:out value="${fieldErrors.zipCode}" />
                </span>
            </div>
            <div class="campo campo-completo">
                <label>Logradouro <span class="obrigatorio">*</span></label>
                <input type="text" name="street" placeholder="Ex.: Rua das Acácias" />
                <span class="campo-erro" data-erro-de="street">
                    <c:out value="${fieldErrors.street}" />
                </span>
            </div>
            <div class="campo">
                <label>Número <span class="obrigatorio">*</span></label>
                <input type="text" name="number" placeholder="Ex.: 220" />
                <span class="campo-erro" data-erro-de="number">
                    <c:out value="${fieldErrors.number}" />
                </span>
            </div>
            <div class="campo">
                <label>Complemento</label>
                <input type="text" name="complement" placeholder="Ex.: Bloco B, Apto 12" />
                <span class="campo-erro" data-erro-de="complement">
                    <c:out value="${fieldErrors.complement}" />
                </span>
            </div>
            <div class="campo">
                <label>Bairro <span class="obrigatorio">*</span></label>
                <input type="text" name="neighborhood" placeholder="Ex.: Centro" />
                <span class="campo-erro" data-erro-de="neighborhood">
                    <c:out value="${fieldErrors.neighborhood}" />
                </span>
            </div>
            <div class="campo">
                <label>Cidade <span class="obrigatorio">*</span></label>
                <input type="text" name="city" placeholder="Ex.: São Paulo" />
                <span class="campo-erro" data-erro-de="city">
                    <c:out value="${fieldErrors.city}" />
                </span>
            </div>
            <div class="campo campo-completo">
                <label>Estado <span class="obrigatorio">*</span></label>
                <input type="text" name="state" placeholder="Ex.: São Paulo" />
                <span class="campo-erro" data-erro-de="state">
                    <c:out value="${fieldErrors.state}" />
                </span>
            </div>

            <div class="modal-rodape campo-completo">
                <a href="${pageContext.request.contextPath}/enderecos" class="btn btn-secundario">Cancelar</a>
                <button type="submit" class="btn btn-primario">Cadastrar endereço</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal: Editar endereço -->
<div class="modal-overlay ${not empty enderecoEditar ? 'aberto' : ''}" id="modal-endereco-editar">
    <div class="modal">
        <div class="modal-cabecalho">
            <h3 class="modal-titulo">Editar endereço</h3>
            <a href="${pageContext.request.contextPath}/enderecos" class="modal-fechar">&times;</a>
        </div>
        <p class="modal-subtitulo">Revise os dados do registro. * Campos obrigatórios.</p>

        <form class="modal-corpo"
              action="${pageContext.request.contextPath}/enderecos"
              method="post"
              data-formulario="endereco"
              novalidate>
            <input type="hidden" name="acao" value="atualizar" />
            <input type="hidden" name="id" value="${enderecoEditar.addressId}" />

            <div class="campo">
                <label>CEP <span class="obrigatorio">*</span></label>
                <input type="text" name="zipCode" value="<c:out value='${enderecoEditar.zipCode}' />" data-mascara="cep" />
                <span class="campo-erro" data-erro-de="zipCode">
                    <c:out value="${fieldErrors.zipCode}" />
                </span>
            </div>
            <div class="campo campo-completo">
                <label>Logradouro <span class="obrigatorio">*</span></label>
                <input type="text" name="street" value="<c:out value='${enderecoEditar.street}' />" />
                <span class="campo-erro" data-erro-de="street">
                    <c:out value="${fieldErrors.street}" />
                </span>
            </div>
            <div class="campo">
                <label>Número <span class="obrigatorio">*</span></label>
                <input type="text" name="number" value="<c:out value='${enderecoEditar.number}' />" />
                <span class="campo-erro" data-erro-de="number">
                    <c:out value="${fieldErrors.number}" />
                </span>
            </div>
            <div class="campo">
                <label>Complemento</label>
                <input type="text" name="complement" value="<c:out value='${enderecoEditar.complement}' />" />
                <span class="campo-erro" data-erro-de="complement">
                    <c:out value="${fieldErrors.complement}" />
                </span>
            </div>
            <div class="campo">
                <label>Bairro <span class="obrigatorio">*</span></label>
                <input type="text" name="neighborhood" value="<c:out value='${enderecoEditar.neighborhood}' />" />
                <span class="campo-erro" data-erro-de="neighborhood">
                    <c:out value="${fieldErrors.neighborhood}" />
                </span>
            </div>
            <div class="campo">
                <label>Cidade <span class="obrigatorio">*</span></label>
                <input type="text" name="city" value="<c:out value='${enderecoEditar.city}' />" />
                <span class="campo-erro" data-erro-de="city">
                    <c:out value="${fieldErrors.city}" />
                </span>
            </div>
            <div class="campo campo-completo">
                <label>Estado <span class="obrigatorio">*</span></label>
                <input type="text" name="state" value="<c:out value='${enderecoEditar.state}' />" />
                <span class="campo-erro" data-erro-de="state">
                    <c:out value="${fieldErrors.state}" />
                </span>
            </div>

            <div class="modal-rodape campo-completo">
                <a href="${pageContext.request.contextPath}/enderecos" class="btn btn-secundario">Cancelar</a>
                <button type="submit" class="btn btn-primario">Salvar alterações</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal: Detalhes do endereço -->
<div class="modal-overlay ${not empty enderecoVer ? 'aberto' : ''}" id="modal-endereco-ver">
    <div class="modal">
        <div class="modal-cabecalho">
            <h3 class="modal-titulo">Detalhes do endereço</h3>
            <a href="${pageContext.request.contextPath}/enderecos" class="modal-fechar">&times;</a>
        </div>
        <p class="modal-subtitulo">Consulte os dados completos e o histórico do cadastro.</p>

        <div class="detalhes-grid">
            <div class="detalhe">
                <div class="detalhe-label">Código</div>
                <div class="detalhe-valor">END-<c:out value="${enderecoVer.addressId}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">CEP</div>
                <div class="detalhe-valor"><c:out value="${enderecoVer.zipCode}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Logradouro</div>
                <div class="detalhe-valor"><c:out value="${enderecoVer.street}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Número</div>
                <div class="detalhe-valor"><c:out value="${enderecoVer.number}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Complemento</div>
                <div class="detalhe-valor">
                    <c:choose>
                        <c:when test="${not empty enderecoVer.complement}">
                            <c:out value="${enderecoVer.complement}" />
                        </c:when>
                        <c:otherwise>—</c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Bairro</div>
                <div class="detalhe-valor"><c:out value="${enderecoVer.neighborhood}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Cidade</div>
                <div class="detalhe-valor"><c:out value="${enderecoVer.city}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Estado</div>
                <div class="detalhe-valor"><c:out value="${enderecoVer.state}" /></div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Loja vinculada</div>
                <div class="detalhe-valor">
                    <c:choose>
                        <c:when test="${not empty enderecoVer.storeName}">
                            <c:out value="${enderecoVer.storeName}" />
                        </c:when>
                        <c:otherwise>Não vinculado</c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Data de criação</div>
                <div class="detalhe-valor">
                    <c:choose>
                        <c:when test="${not empty enderecoVer.createdAt}">
                            <c:out value="${enderecoVer.createdAtFormatted}" />
                        </c:when>
                        <c:otherwise>—</c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="detalhe">
                <div class="detalhe-label">Data de exclusão</div>
                <div class="detalhe-valor">
                    <c:choose>
                        <c:when test="${not empty enderecoVer.deletedAt}">
                            <c:out value="${enderecoVer.deletedAtFormatted}" />
                        </c:when>
                        <c:otherwise>Não excluído</c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div class="modal-rodape">
            <a href="${pageContext.request.contextPath}/enderecos" class="btn btn-secundario">Fechar</a>
        </div>
    </div>
</div>

<!-- Modal: Confirmar exclusão -->
<div class="modal-overlay ${not empty enderecoExcluir ? 'aberto' : ''}" id="modal-endereco-excluir">
    <div class="modal modal-pequeno">
        <h3 class="confirmacao-titulo">Tem certeza que deseja excluir?</h3>
        <p class="confirmacao-texto">
            O endereço
            <strong>END-<c:out value="${enderecoExcluir.addressId}" /> &mdash;
                <c:out value="${enderecoExcluir.street}" />, <c:out value="${enderecoExcluir.number}" /></strong>
            será removido da listagem.
        </p>

        <form action="${pageContext.request.contextPath}/enderecos" method="post">
            <input type="hidden" name="acao" value="excluir" />
            <input type="hidden" name="id" value="${enderecoExcluir.addressId}" />
            <div class="modal-rodape">
                <a href="${pageContext.request.contextPath}/enderecos" class="btn btn-secundario">Cancelar</a>
                <button type="submit" class="btn btn-perigo">Excluir endereço</button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/crud.js"></script>
</body>
</html>