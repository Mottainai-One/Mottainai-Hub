/*
  Painel Administrativo Mottainai - config.js

  Este arquivo roda tanto no VS Code (HTML estático) quanto no IntelliJ (JSP).
  Os trechos marcados com [JSP] vão ser removidos ou alterados quando virar Servlet.
  Os trechos marcados com [FICA] continuam iguais na JSP.
*/

const overlays = document.querySelectorAll(".modal-overlay");

function abrirModal(id) {
  const overlay = document.getElementById(id);
  if (!overlay) return;

  overlay.classList.add("aberto");
  document.body.style.overflow = "hidden";
}

function fecharModal(overlay) {
  if (!overlay) return;

  overlay.classList.remove("aberto");

  if (document.querySelectorAll(".modal-overlay.aberto").length === 0) {
    document.body.style.overflow = "";
  }
}

// Botões que abrem modais (data-abrir-modal="id-do-modal")
document.querySelectorAll("[data-abrir-modal]").forEach((botao) => {
  botao.addEventListener("click", () => {
    abrirModal(botao.dataset.abrirModal);
  });
});

// Botões que fecham modais (data-fechar-modal)
document.querySelectorAll("[data-fechar-modal]").forEach((botao) => {
  botao.addEventListener("click", () => {
    fecharModal(botao.closest(".modal-overlay"));
  });
});

// Fechar ao clicar fora do modal
overlays.forEach((overlay) => {
  overlay.addEventListener("click", (e) => {
    if (e.target === overlay) fecharModal(overlay);
  });
});

// Fechar com ESC
document.addEventListener("keydown", (e) => {
  if (e.key === "Escape") {
    const aberto = document.querySelector(".modal-overlay.aberto");
    if (aberto) fecharModal(aberto);
  }
});

// CNPJ: 00.000.000/0000-00
function mascaraCNPJ(valor) {
  return valor
    .replace(/\D/g, "")
    .slice(0, 14)
    .replace(/^(\d{2})(\d)/, "$1.$2")
    .replace(/^(\d{2})\.(\d{3})(\d)/, "$1.$2.$3")
    .replace(/\.(\d{3})(\d)/, ".$1/$2")
    .replace(/(\d{4})(\d)/, "$1-$2");
}

// Telefone: (00) 00000-0000
function mascaraTelefone(valor) {
  return valor
    .replace(/\D/g, "")
    .slice(0, 11)
    .replace(/^(\d{2})(\d)/, "($1) $2")
    .replace(/(\d{5})(\d)/, "$1-$2");
}

// CPF: 000.000.000-00
function mascaraCPF(valor) {
  return valor
    .replace(/\D/g, "")
    .slice(0, 11)
    .replace(/^(\d{3})(\d)/, "$1.$2")
    .replace(/^(\d{3})\.(\d{3})(\d)/, "$1.$2.$3")
    .replace(/\.(\d{3})(\d)/, ".$1-$2");
}

// CEP: 00000-000
function mascaraCEP(valor) {
  return valor
    .replace(/\D/g, "")
    .slice(0, 8)
    .replace(/^(\d{5})(\d)/, "$1-$2");
}

// Moeda: 0,00 / 000,00 / 000.000,00
function mascaraMoeda(valor) {
  const digitos = valor.replace(/\D/g, "");
  if (!digitos) return "";

  const numero = parseInt(digitos, 10) / 100;
  return numero.toLocaleString("pt-BR", {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  });
}


document.addEventListener("input", (e) => {
  const input = e.target;
  if (!input.dataset || !input.dataset.mascara) return;

  switch (input.dataset.mascara) {
    case "cnpj":
      input.value = mascaraCNPJ(input.value);
      break;
    case "telefone":
      input.value = mascaraTelefone(input.value);
      break;
    case "cpf":
      input.value = mascaraCPF(input.value);
      break;
    case "cep":
      input.value = mascaraCEP(input.value);
      break;
    case "moeda":
      input.value = mascaraMoeda(input.value);
      break;
  }
});

function marcarErro(campo, mensagem) {
  campo.classList.add("com-erro");
  const span = campo.querySelector(".campo-erro");
  if (span) span.textContent = mensagem;
}

function limparErro(campo) {
  campo.classList.remove("com-erro");
  const span = campo.querySelector(".campo-erro");
  if (span) span.textContent = "";
}

// Campo obrigatório
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

// E-mail: formato usuario@dominio.tld
function validarEmail(campo) {
  const input = campo.querySelector("input");
  if (!input) return true;
  if (!input.value.trim()) return true;

  const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!regex.test(input.value.trim())) {
    marcarErro(campo, "Informe um e-mail válido.");
    return false;
  }
  limparErro(campo);
  return true;
}

// CNPJ: 14 dígitos
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

// CPF: 11 dígitos
function validarCPF(campo) {
  const input = campo.querySelector("input");
  if (!input) return true;
  if (!input.value.trim()) return true;

  const digitos = input.value.replace(/\D/g, "");
  if (digitos.length !== 11) {
    marcarErro(campo, "CPF deve ter 11 dígitos.");
    return false;
  }
  limparErro(campo);
  return true;
}

// Telefone: 10 (fixo) ou 11 (celular) dígitos
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

// CEP: 8 dígitos
function validarCEP(campo) {
  const input = campo.querySelector("input");
  if (!input) return true;
  if (!input.value.trim()) return true;

  const digitos = input.value.replace(/\D/g, "");
  if (digitos.length !== 8) {
    marcarErro(campo, "CEP deve ter 8 dígitos.");
    return false;
  }
  limparErro(campo);
  return true;
}

// Moeda: precisa ser número maior que zero
function validarMoeda(campo) {
  const input = campo.querySelector("input");
  if (!input) return true;
  if (!input.value.trim()) return true;

  const texto = input.value.replace(/\./g, "").replace(",", ".");
  const numero = Number(texto);
  if (Number.isNaN(numero) || numero <= 0) {
    marcarErro(campo, "Informe um valor maior que zero.");
    return false;
  }
  limparErro(campo);
  return true;
}

// Decimal (latitude/longitude)
function validarNumeroDecimal(campo) {
  const input = campo.querySelector("input");
  if (!input) return true;
  if (!input.value.trim()) return true;

  const numero = Number(input.value.replace(",", "."));
  if (Number.isNaN(numero)) {
    marcarErro(campo, "Informe um número válido.");
    return false;
  }
  limparErro(campo);
  return true;
}

// Inteiro positivo (limite de lojas, limite de usuários, nível de permissão)
function validarInteiroPositivo(campo) {
  const input = campo.querySelector("input");
  if (!input) return true;
  if (!input.value.trim()) return true;

  const numero = parseInt(input.value, 10);
  if (Number.isNaN(numero) || numero < 1) {
    marcarErro(campo, "Informe um número inteiro maior que zero.");
    return false;
  }
  limparErro(campo);
  return true;
}

// Data (hireDate, data de admissão)
function validarData(campo) {
  const input = campo.querySelector("input");
  if (!input) return true;
  if (!input.value.trim()) return true;

  const data = new Date(input.value);
  if (Number.isNaN(data.getTime())) {
    marcarErro(campo, "Informe uma data válida.");
    return false;
  }
  if (data > new Date()) {
    marcarErro(campo, "A data não pode ser no futuro.");
    return false;
  }
  limparErro(campo);
  return true;
}

// Senha: mínimo 8 caracteres (igual ao CHECK do banco)
function validarSenha(campo) {
  const input = campo.querySelector("input");
  if (!input) return true;
  if (!input.value.trim()) return true;

  if (input.value.length < 8) {
    marcarErro(campo, "Senha deve ter no mínimo 8 caracteres.");
    return false;
  }
  limparErro(campo);
  return true;
}

// Roteador: aplica a validação certa conforme o name do input
function validarCampo(campo) {
  const input = campo.querySelector("input, select");
  if (!input) return true;

  const name = input.name;
  const temAsterisco = campo.querySelector(".obrigatorio");
  let ok = true;

  if (temAsterisco) ok = validarObrigatorio(campo) && ok;

  if (name === "email") ok = validarEmail(campo) && ok;
  if (name === "cnpj") ok = validarCNPJ(campo) && ok;
  if (name === "cpf") ok = validarCPF(campo) && ok;
  if (name === "phone") ok = validarTelefone(campo) && ok;
  if (name === "zipCode") ok = validarCEP(campo) && ok;
  if (name === "price") ok = validarMoeda(campo) && ok;
  if (name === "latitude" || name === "longitude")
    ok = validarNumeroDecimal(campo) && ok;
  if (
    name === "permissionLevel" ||
    name === "storeLimit" ||
    name === "userLimit"
  )
    ok = validarInteiroPositivo(campo) && ok;
  if (name === "hireDate") ok = validarData(campo) && ok;
  if (name === "password") ok = validarSenha(campo) && ok;

  return ok;
}

// ==========================================================================
// 4. SUBMIT DOS FORMULÁRIOS
// [JSP: ALTERAR] No VS Code, o e.preventDefault() impede o envio e fecha o
// modal. Na JSP, você REMOVE o preventDefault e o form vai para o Servlet
// (action="empresas" method="post"). O Servlet redireciona após salvar.
// ==========================================================================

document.querySelectorAll("[data-formulario]").forEach((form) => {
  form.addEventListener("submit", (e) => {
    // [JSP: REMOVER] Quando virar JSP, essa linha sai, e o form envia de verdade
    e.preventDefault();

    // [JSP: MANTER] Ignora o form "ir-pagina" aqui (validação própria abaixo)
    if (form.dataset.formulario === "ir-pagina") return;

    // [JSP: MANTER] Validação client-side (continua fazendo sentido na JSP)
    const campos = form.querySelectorAll(".campo");
    let tudoOk = true;

    campos.forEach((campo) => {
      const ok = validarCampo(campo);
      if (!ok) tudoOk = false;
    });

    if (!tudoOk) {
      const primeiroErro = form.querySelector(
        ".campo.com-erro input, .campo.com-erro select"
      );
      if (primeiroErro) primeiroErro.focus();
      return;
    }

    // [JSP: REMOVER] Fechar modal e limpar form após "salvar" é coisa de maquete.
    // Na JSP, quem faz isso é o Servlet: salva no banco e redireciona.
    const overlay = form.closest(".modal-overlay");
    if (overlay) fecharModal(overlay);
    form.reset();
  });
});

// Validação em tempo real ao sair do campo (blur)
// [FICA] Continua igual na JSP.
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
// [JSP: ALTERAR] No VS Code, isso valida o número e fecha o modal.
// Na JSP, o ideal é que "ir para página" vire um link: <a href="empresas?pagina=5">.
// Ou, se você quiser manter o modal, o form POST vai pro Servlet ler o parâmetro.
// ==========================================================================

const formIrPagina = document.querySelector('[data-formulario="ir-pagina"]');

if (formIrPagina) {
  formIrPagina.addEventListener("submit", (e) => {
    e.preventDefault();

    const campo = formIrPagina.querySelector(".campo");
    const input = formIrPagina.querySelector("input");
    const valor = parseInt(input.value, 10);

    // [FICA] Validação do número da página (continua fazendo sentido)
    if (isNaN(valor) || valor < 1 || valor > 10) {
      marcarErro(campo, "Informe um número entre 1 e 10.");
      input.focus();
      return;
    }

    limparErro(campo);

    // [JSP: REMOVER] No VS Code, só fecha o modal.
    // Na JSP, essa linha vira: window.location.href = "empresas?pagina=" + valor;
    // ou o form envia via POST para o Servlet.
    const overlay = formIrPagina.closest(".modal-overlay");
    if (overlay) fecharModal(overlay);
    formIrPagina.reset();
  });
}