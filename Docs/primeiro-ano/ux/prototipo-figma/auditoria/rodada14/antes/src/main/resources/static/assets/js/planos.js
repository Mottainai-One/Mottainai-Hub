const secao = document.getElementById("escolha-plano");
const toggle = document.getElementById("toggle-plano");
const retangulo = document.getElementById("retangulo");
const opcaoMensal = document.getElementById("mensal");
const opcaoAnual = document.getElementById("anual");

const PRECOS = {
  mensal: { essentials: 1200, professional: 3500 },
  anual: { essentials: 10000, professional: 28000 },
};

const DURACAO_MS = 600;
const elPrecos = {
  essentials: document.querySelector(
    ".card-plano:not(#principal):first-child .preco strong",
  ),
  professional: document.querySelector("#principal .preco strong"),
};

let modo = "mensal";
const animacoesPreco = new Map();
function prepararToggle() {
  toggle.insertBefore(opcaoMensal, retangulo);
  retangulo.classList.add("deslizante");
  posicionarRetangulo(false);
}

function posicionarRetangulo(animar = true) {
  const alvo = modo === "mensal" ? opcaoMensal : opcaoAnual;
  retangulo.style.transition = animar ? "" : "none";
  retangulo.style.width = `${alvo.offsetWidth}px`;
  retangulo.style.height = `${alvo.offsetHeight}px`;
  retangulo.style.transform = `translateX(${alvo.offsetLeft}px)`;
  if (!animar)
    (retangulo.getBoundingClientRect(), (retangulo.style.transition = ""));
}

/* ---------- Contagem dos preços ---------- */
const formatarBRL = (n) => `R$ ${Math.round(n).toLocaleString("pt-BR")}`;
const easeOutCubic = (t) => 1 - Math.pow(1 - t, 3);

function animarPreco(el, de, para) {
  cancelAnimationFrame(animacoesPreco.get(el));
  const inicio = performance.now();

  function frame(agora) {
    const t = Math.min((agora - inicio) / DURACAO_MS, 1);
    el.textContent = formatarBRL(de + (para - de) * easeOutCubic(t));
    if (t < 1) animacoesPreco.set(el, requestAnimationFrame(frame));
  }
  animacoesPreco.set(el, requestAnimationFrame(frame));
}

function valorAtual(el) {
  return Number(el.textContent.replace(/\D/g, "")) || 0;
}

function definirModo(novoModo) {
  if (novoModo === modo) return;
  modo = novoModo;

  secao.classList.toggle("anual", modo === "anual");
  opcaoMensal.classList.toggle("ativa", modo === "mensal");
  opcaoAnual.classList.toggle("ativa", modo === "anual");
  posicionarRetangulo();

  for (const plano in elPrecos) {
    const el = elPrecos[plano];
    animarPreco(el, valorAtual(el), PRECOS[modo][plano]);
  }
}

opcaoMensal.addEventListener("click", () => definirModo("mensal"));
opcaoAnual.addEventListener("click", () => definirModo("anual"));
window.addEventListener("resize", () => posicionarRetangulo(false));

prepararToggle();
opcaoMensal.classList.add("ativa");
document.fonts?.ready.then(() => posicionarRetangulo(false));
