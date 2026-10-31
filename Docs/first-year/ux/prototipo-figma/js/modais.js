// Os radios do layout recebido controlam abertura, fechamento e alternância dos modais.
document.addEventListener("keydown", (event) => {
  if (event.key === "Escape") document.getElementById("fechar").checked = true;
});

// O destino externo ainda não foi fornecido: Enter nunca deve enviar Cadastro à Home ou ao backend.
document.getElementById("cadastro-form").addEventListener("submit", (event) => event.preventDefault());
