/*
  Painel Administrativo Mottainai - app.js

  Este arquivo é compartilhado por todas as páginas do painel:
    - PaginaInicial.html
    - Empresas.html
    - Lojas.html
    - Funcionario.html

  Responsabilidades:
    1. Marcar o item ativo do menu lateral conforme a página
    2. Abrir e fechar modais
    3. Aplicar máscaras (CNPJ e telefone)
    4. Validar formulários antes do envio
    5. Validar campos em tempo real ao sair do foco (blur)
    6. Modal "ir para página" com validação específica

  Não faz CRUD. A persistência de dados fica para o backend (Servlet).
*/

// ==========================================================================
// 1. MENU LATERAL - ITEM ATIVO
// ==========================================================================

/*
  Cada página declara no <body> qual item do menu deve ficar ativo:
    <body data-pagina="empresas">
  O script lê esse atributo e marca o link correspondente com a classe .ativo.
  Isso evita ter que editar o HTML da sidebar em cada página.
*/
(function marcarItemAtivo() {
  const paginaAtual = document.body.dataset.pagina;
  if (!paginaAtual) return;

  const itemAtivo = document.querySelector(
    `.sidebar-item[data-pagina="${paginaAtual}"]`
  );
  if (itemAtivo) itemAtivo.classList.add("ativo");
})();

// ==========================================================================
// 2. MODAIS - ABRIR E FECHAR
// ==========================================================================

const overlays = document.querySelectorAll(".modal-overlay");

function abrirModal(id) {
  
  const overlay = document.getElementById(id);
  if (!overlay) return;

  overlay.classList.add("aberto");
  // Trava o scroll do fundo enquanto o modal está aberto
  document.body.style.overflow = "hidden";
}

function fecharModal(overlay) {
  if (!overlay) return;

  overlay.classList.remove("aberto");

  // Só destrava o scroll se nenhum outro modal estiver aberto
  if (document.querySelectorAll(".modal-overlay.aberto").length === 0) {
    document.body.style.overflow = "";
  }
}

/*
  Botões que abrem modais:
    <button data-abrir-modal="modal-empresa-criar">...</button>
  O valor do atributo é o id do <div class="modal-overlay">.
*/
document.querySelectorAll("[data-abrir-modal]").forEach((botao) => {
  botao.addEventListener("click", () => {
    
    abrirModal(botao.dataset.abrirModal);
    
  });
});

/*
  Botões que fecham modais:
    <button data-fechar-modal>Cancelar</button>
    <button class="modal-fechar" data-fechar-modal>×</button>
  O botão precisa estar dentro do .modal-overlay para o fechamento funcionar.
*/
document.querySelectorAll("[data-fechar-modal]").forEach((botao) => {
  botao.addEventListener("click", () => {
    fecharModal(botao.closest(".modal-overlay"));
  });
});

/*
  Fechar ao clicar fora da caixa do modal (no overlay).
  Só dispara se o clique foi exatamente no overlay, não em elemento filho.
*/
overlays.forEach((overlay) => {
  overlay.addEventListener("click", (e) => {
    if (e.target === overlay) fecharModal(overlay);
  });
});

/*
  Fechar com a tecla ESC.
*/
document.addEventListener("keydown", (e) => {
  if (e.key === "Escape") {
    const aberto = document.querySelector(".modal-overlay.aberto");
    if (aberto) fecharModal(aberto);
  }
});

// ==========================================================================
// 3. MÁSCARAS
// ==========================================================================

// Máscara de CNPJ: 00.000.000/0000-00
function mascaraCNPJ(valor) {
  return valor
    .replace(/\D/g, "")                            // remove tudo que não é dígito
    .slice(0, 14)                                  // no máximo 14 dígitos
    .replace(/^(\d{2})(\d)/, "$1.$2")              // 00.
    .replace(/^(\d{2})\.(\d{3})(\d)/, "$1.$2.$3")  // 00.000.
    .replace(/\.(\d{3})(\d)/, ".$1/$2")            // 00.000.000/
    .replace(/(\d{4})(\d)/, "$1-$2");              // 0000-00
}

// Máscara de telefone: (00) 00000-0000
function mascaraTelefone(valor) {
  return valor
    .replace(/\D/g, "")                            // remove tudo que não é dígito
    .slice(0, 11)                                  // no máximo 11 dígitos (celular)
    .replace(/^(\d{2})(\d)/, "($1) $2")            // (00) 0
    .replace(/(\d{5})(\d)/, "$1-$2");              // 00000-0000
}

/*
  Delegação de evento: qualquer input que tenha data-mascara="cnpj" ou
  data-mascara="telefone" recebe a máscara automaticamente.
*/
document.addEventListener("input", (e) => {
  const input = e.target;
  if (!input.dataset || !input.dataset.mascara) return;

  if (input.dataset.mascara === "cnpj") {
    input.value = mascaraCNPJ(input.value);
  } else if (input.dataset.mascara === "telefone") {
    input.value = mascaraTelefone(input.value);
  }
});

// ==========================================================================
// 4. VALIDAÇÕES
// ==========================================================================

/*
  Cada <div class="campo"> tem três partes:
    - <label>            (rótulo, com <span class="obrigatorio"> quando for obrigatório)
    - <input> ou <select>
    - <span class="campo-erro" data-erro-de="nomeDoCampo">

  As funções abaixo alteram a classe .com-erro no <div class="campo"> e escrevem
  a mensagem no <span class="campo-erro">. O CSS cuida da cor vermelha.
*/

// Exibe erro no campo
function marcarErro(campo, mensagem) {
  campo.classList.add("com-erro");
  const span = campo.querySelector(".campo-erro");
  if (span) span.textContent = mensagem;
}

// Remove o erro do campo
function limparErro(campo) {
  campo.classList.remove("com-erro");
  const span = campo.querySelector(".campo-erro");
  if (span) span.textContent = "";
}

// [VALIDAÇÃO] Campo obrigatório: precisa ter valor não vazio
function validarObrigatorio(campo) {
  const input = campo.querySelector("input, select");
  if (!input) return true;

  if (!input.value.trim()) {
    marcarErro(campo, "Este campo é obrigatório.");
    return false;
  }
  limparErro(campo);
  return true;
}

// [VALIDAÇÃO] E-mail: formato básico usuario@dominio.tld
function validarEmail(campo) {
  const input = campo.querySelector("input");
  if (!input) return true;

  // Se estiver vazio, deixa o validarObrigatorio cuidar
  if (!input.value.trim()) return true;

  const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!regex.test(input.value.trim())) {
    marcarErro(campo, "Informe um e-mail válido.");
    return false;
  }
  limparErro(campo);
  return true;
}

// [VALIDAÇÃO] CNPJ: exige 14 dígitos (não valida dígitos verificadores)
function validarCNPJ(campo) {
  const input = campo.querySelector("input");
  if (!input) return true;

  if (!input.value.trim()) return true;

  const digitos = input.value.replace(/\D/g, "");
  if (digitos.length !== 14) {
    marcarErro(campo, "CNPJ deve ter 14 dígitos.");
    return false;
  }
  limparErro(campo);
  return true;
}

// [VALIDAÇÃO] Telefone: 10 (fixo) ou 11 (celular) dígitos
function validarTelefone(campo) {
  const input = campo.querySelector("input");
  if (!input) return true;

  if (!input.value.trim()) return true;

  const digitos = input.value.replace(/\D/g, "");
  if (digitos.length !== 10 && digitos.length !== 11) {
    marcarErro(campo, "Telefone deve ter 10 ou 11 dígitos.");
    return false;
  }
  limparErro(campo);
  return true;
}

// [VALIDAÇÃO] Número decimal: usado em latitude e longitude
function validarNumeroDecimal(campo) {
  const input = campo.querySelector("input");
  if (!input) return true;

  if (!input.value.trim()) return true;

  // Aceita vírgula ou ponto como separador decimal
  const numero = Number(input.value.replace(",", "."));
  if (Number.isNaN(numero)) {
    marcarErro(campo, "Informe um número válido.");
    return false;
  }
  limparErro(campo);
  return true;
}

/*
  Roteador de validação: olha o name do input do campo e aplica as regras
  que fazem sentido. É chamado tanto no submit quanto no blur.
*/
function validarCampo(campo) {
  const input = campo.querySelector("input, select");
  if (!input) return true;

  const name = input.name;
  const temAsterisco = campo.querySelector(".obrigatorio");
  let ok = true;

  if (temAsterisco) ok = validarObrigatorio(campo) && ok;

  if (name === "email") ok = validarEmail(campo) && ok;
  if (name === "cnpj") ok = validarCNPJ(campo) && ok;
  if (name === "phone") ok = validarTelefone(campo) && ok;
  if (name === "latitude" || name === "longitude")
    ok = validarNumeroDecimal(campo) && ok;

  return ok;
}

/*
  Intercepta o submit dos formulários que têm data-formulario.
  Roda a validação em todos os campos. Se tudo estiver ok, fecha o modal
  e limpa o formulário. Sem backend, não há envio real.
*/
document.querySelectorAll("[data-formulario]").forEach((form) => {
  form.addEventListener("submit", (e) => {
    e.preventDefault();

    // Ignora o formulário "ir-pagina" aqui (ele tem sua própria validação abaixo)
    if (form.dataset.formulario === "ir-pagina") return;

    const campos = form.querySelectorAll(".campo");
    let tudoOk = true;

    campos.forEach((campo) => {
      const ok = validarCampo(campo);
      if (!ok) tudoOk = false;
    });

    if (!tudoOk) {
      // Foca no primeiro campo com erro
      const primeiroErro = form.querySelector(
        ".campo.com-erro input, .campo.com-erro select"
      );
      if (primeiroErro) primeiroErro.focus();
      return;
    }

    // Sem backend: fecha o modal e limpa o formulário
    const overlay = form.closest(".modal-overlay");
    if (overlay) fecharModal(overlay);
    form.reset();
  });
});

/*
  Validação em tempo real: quando o usuário sai de um campo (blur), roda a
  validação daquele campo. Assim o erro aparece antes do submit.
  O terceiro parâmetro (true) captura o blur, que não borbulha por padrão.
*/
document.addEventListener(
  "blur",
  (e) => {
    const input = e.target;
    if (!input.matches || !input.matches("input, select")) return;
    const campo = input.closest(".campo");
    if (!campo) return;
    validarCampo(campo);
  },
  true
);

// ==========================================================================
// 5. MODAL "IR PARA PÁGINA"
// ==========================================================================

/*
  O formulário com data-formulario="ir-pagina" tem regra própria:
  o valor precisa ser um número inteiro entre 1 e 10.
  A validação é feita aqui, separada das outras.
*/
const formIrPagina = document.querySelector('[data-formulario="ir-pagina"]');

if (formIrPagina) {
  formIrPagina.addEventListener("submit", (e) => {
    e.preventDefault();

    const campo = formIrPagina.querySelector(".campo");
    const input = formIrPagina.querySelector("input");
    const valor = parseInt(input.value, 10);

    // [VALIDAÇÃO] Número inteiro entre 1 e 10
    if (isNaN(valor) || valor < 1 || valor > 10) {
      marcarErro(campo, "Informe um número entre 1 e 10.");
      input.focus();
      return;
    }

    limparErro(campo);

    // Sem backend: apenas fecha o modal.
    // Na versão JSP, aqui você faria window.location.href = "...?pagina=" + valor;
    const overlay = formIrPagina.closest(".modal-overlay");
    if (overlay) fecharModal(overlay);
    formIrPagina.reset();
  });
}