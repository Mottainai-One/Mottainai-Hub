/* MOTTAINAI — config.js INTEGRADO a partir do arquivo enviado.
   SUBSTITUI o config.js administrativo antigo; não carregue ambos.
   Formulários válidos são enviados normalmente ao backend Spring/JSP.
*/
/*
  Painel Administrativo Mottainai - Spring MVC/JSP

  Este arquivo é compartilhado por todas as páginas do painel:
    - home-crud-page.jsp
    - companies.jsp
    - stores.jsp
    - employees.jsp e demais JSPs administrativos

  Responsabilidades:
    1. Marcar o item ativo do menu lateral conforme a página
    2. Abrir e fechar modais
    3. Aplicar máscaras (CNPJ e telefone)
    4. Validar formulários antes do envio
    5. Validar campos em tempo real ao sair do foco (blur)
    6. Modal "ir para página" com validação específica

  Não faz CRUD. A persistência de dados fica para o backend Spring MVC (Controller e Service).
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
    .replace(/(\d{4,5})(\d{4})$/, "$1-$2");       // fixo ou celular
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

  if (input.disabled || input.readOnly || input.type === "hidden") return true;

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
  Formulários JSP/Spring: valida antes do envio.
  IMPORTANTE: somente bloqueia o submit quando existe erro.
  Se estiver válido, o navegador envia o formulário normalmente ao backend.
  Não fecha o modal nem limpa os campos antes da resposta do servidor.
*/
document.querySelectorAll("[data-formulario]").forEach((form) => {
  form.addEventListener("submit", (e) => {
    if (form.dataset.formulario === "ir-pagina") return;
    const campos = form.querySelectorAll(".campo");
    let tudoOk = true;
    campos.forEach((campo) => {
      if (!validarCampo(campo)) tudoOk = false;
    });
    if (!tudoOk) {
      e.preventDefault();
      const primeiroErro = form.querySelector(
        ".campo.com-erro input, .campo.com-erro select, .campo.com-erro textarea"
      );
      if (primeiroErro) primeiroErro.focus();
    }
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

/* Paginação: valida o inteiro, respeita max definido pelo JSP e permite submit normal. */
const formIrPagina = document.querySelector('[data-formulario="ir-pagina"]');
if (formIrPagina) {
  formIrPagina.addEventListener("submit", (e) => {
    const campo = formIrPagina.querySelector(".campo");
    const input = formIrPagina.querySelector("input");
    if (!input) return;
    const valor = Number(input.value);
    const minimo = Number(input.min) > 0 ? Number(input.min) : 1;
    const maximo = Number(input.max) > 0 ? Number(input.max) : Infinity;
    if (!Number.isInteger(valor) || valor < minimo || valor > maximo) {
      e.preventDefault();
      if (campo) marcarErro(campo, `Informe uma página entre ${minimo} e ${Number.isFinite(maximo) ? maximo : "o limite disponível"}.`);
      input.focus();
      return;
    }
    if (campo) limparErro(campo);
    // A action do formulário JSP define o destino da paginação.
  });
}

/* Melhorias do CRUD V35 — CPF, CEP, telefone e indicadores visuais. */
(function melhorarCrudV35() {
  if (!document.body || !document.body.hasAttribute("data-pagina")) return;
  const apenasDigitos = (v) => String(v ?? "").replace(/\D/g, "");
  function tipo(input) {
    const texto = [input.name, input.id, input.dataset.mascara, input.dataset.mask].filter(Boolean).join(" ").toLowerCase();
    if (/cnpj/.test(texto)) return "cnpj";
    if (/cpf/.test(texto)) return "cpf";
    if (/cep/.test(texto)) return "cep";
    if (/telefone|celular|phone/.test(texto)) return "telefone";
    return "";
  }
  const formatar = {
    cpf(v) { return apenasDigitos(v).slice(0,11).replace(/^(\d{3})(\d)/,"$1.$2").replace(/^(\d{3})\.(\d{3})(\d)/,"$1.$2.$3").replace(/\.(\d{3})(\d)/,".$1-$2"); },
    cnpj: mascaraCNPJ,
    cep(v) { return apenasDigitos(v).slice(0,8).replace(/^(\d{5})(\d)/,"$1-$2"); },
    telefone(v) { const n=apenasDigitos(v).slice(0,11); if(n.length<3) return n ? "("+n : ""; const t=n.length>10?5:4; const r=n.slice(2); return "("+n.slice(0,2)+") "+r.slice(0,t)+(r.length>t?"-"+r.slice(t):""); }
  };
  document.addEventListener("input", (e) => {
    const el=e.target;
    if (!(el instanceof HTMLInputElement) || el.disabled || el.readOnly) return;
    const t=tipo(el);
    if (!t) return;
    el.value=formatar[t](el.value);
    el.removeAttribute("aria-invalid");
  });
  function cpfValido(v) {
    const n=apenasDigitos(v);
    if(n.length!==11 || /^(\d)\1+$/.test(n)) return false;
    for(let pos=9;pos<=10;pos++) {
      let soma=0;
      for(let i=0;i<pos;i++) soma+=Number(n[i])*(pos+1-i);
      let digito=(soma*10)%11;
      if(digito===10) digito=0;
      if(digito!==Number(n[pos])) return false;
    }
    return true;
  }
  function validarExtra(el) {
    // Campos técnicos/imutáveis não devem bloquear ações Spring por causa de máscaras ou marcadores.
    if (el.disabled || el.readOnly || el.type === "hidden") return true;
    const t=tipo(el);
    if(!t || !el.value.trim()) return true;
    const n=apenasDigitos(el.value);
    const ok=t==="cpf" ? cpfValido(n) : t==="cnpj" ? n.length===14 : t==="cep" ? n.length===8 : n.length===10 || n.length===11;
    el.toggleAttribute("aria-invalid",!ok);
    if(!ok) {
      const campo=el.closest(".campo");
      if(campo) marcarErro(campo,t==="cpf"?"Informe um CPF válido.":"Confira o formato deste campo.");
    }
    return ok;
  }
  document.addEventListener("blur",(e)=>{
    if(e.target instanceof HTMLInputElement) validarExtra(e.target);
  },true);
  // Usa a fase de captura para impedir o envio de valores inválidos sem alterar
  // as funções originais dos formulários ou a requisição Spring.
  document.addEventListener("submit",(e)=>{
    const form=e.target;
    if(!(form instanceof HTMLFormElement) || !form.closest("body[data-pagina]")) return;
    const inputs=form.querySelectorAll("input");
    let primeiroInvalido=null;
    inputs.forEach((el)=>{if(!validarExtra(el) && !primeiroInvalido) primeiroInvalido=el;});
    if(primeiroInvalido){e.preventDefault();primeiroInvalido.focus();}
  },true);
  document.querySelectorAll(".sidebar-item[data-pagina]").forEach((link)=>{
    if(link.dataset.pagina===document.body.dataset.pagina) link.setAttribute("aria-current","page");
  });
})();

// Somente no HTML estático: Escape fecha o modal nativo por fragmento, sem simular backend.
document.addEventListener("keydown", (event) => {
  if (document.body.dataset.preview === "static" && event.key === "Escape" && document.querySelector(".modal-overlay:target")) location.hash = "";
});
