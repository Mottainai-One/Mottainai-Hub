// Perfil da sessão e filtro das linhas existentes; sem autenticação ou persistência no cliente.
(() => {
  const profile = document.querySelector('.perfil-administrativo');
  const trigger = profile?.querySelector('.perfil-trigger');
  const popup = profile?.querySelector('.perfil-popup');
  if (trigger && popup) {
    const close = () => { popup.hidden = true; trigger.setAttribute('aria-expanded', 'false'); };
    trigger.addEventListener('click', () => {
      popup.hidden = !popup.hidden;
      trigger.setAttribute('aria-expanded', String(!popup.hidden));
    });
    document.addEventListener('click', event => { if (!profile.contains(event.target)) close(); });
    document.addEventListener('keydown', event => { if (event.key === 'Escape' && !popup.hidden) { close(); trigger.focus(); } });
  }
  if (document.currentScript?.hasAttribute('data-profile-only')) return;
  const search = document.querySelector('.toolbar input[name="busca"]');
  const table = document.querySelector('table.tabela');
  if (!search || !table) return;
  const normalize = text => text.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLocaleLowerCase('pt-BR').trim();
  const status = document.createElement('div');
  status.className = 'busca-status'; status.setAttribute('aria-hidden', 'true');
  search.closest('form').after(status);
  const filter = () => {
    const term = normalize(search.value); let shown = 0, total = 0;
    table.querySelectorAll('tbody tr').forEach(row => {
      if (row.cells.length <= 1) return;
      const text = normalize([...row.cells].filter(cell => !cell.classList.contains('col-acoes')).map(cell => cell.textContent).join(' '));
      row.hidden = Boolean(term) && !text.includes(term);
      total++; if (!row.hidden) shown++;
    });
  };
  // Enter e submit continuam livres para executar o GET original.
  search.addEventListener('input', filter);
  search.form.addEventListener('reset', () => setTimeout(filter, 0));
  filter();
})();
