/* Carrossel visual; sem API, persistência ou biblioteca externa. */
(() => {
  const track = document.querySelector('.faq-carrossel');
  if (!track) return;
  const cards = [...track.children];
  const motion = matchMedia('(prefers-reduced-motion: reduce)');
  let timer, frame;
  let paused = false;
  let busy = false;
  // Cópias visuais permitem a passagem contínua sem anunciar avaliações duplicadas.
  cards.forEach(card => {
    const copy = card.cloneNode(true);
    copy.setAttribute('aria-hidden', 'true');
    track.append(copy);
  });
  const schedule = () => {
    clearTimeout(timer);
    if (!paused && !busy && !document.hidden && !motion.matches) timer = setTimeout(advance, 5000);
  };
  const advance = () => {
    const step = track.children[1].offsetLeft - track.children[0].offsetLeft;
    const cycle = step * cards.length;
    if (track.scrollLeft >= cycle - 1) track.scrollLeft -= cycle;
    const start = track.scrollLeft;
    const target = (Math.floor((start + 1) / step) + 1) * step;
    const time = performance.now();
    busy = true;
    const move = now => {
      const t = Math.min(1, (now - time) / 650);
      track.scrollLeft = start + (target - start) * t * t * (3 - 2 * t);
      if (t < 1) frame = requestAnimationFrame(move);
      else { busy = false; schedule(); }
    };
    frame = requestAnimationFrame(move);
  };
  const pause = () => { paused = true; clearTimeout(timer); cancelAnimationFrame(frame); busy = false; };
  track.addEventListener('pointerenter', pause);
  track.addEventListener('pointerdown', pause);
  track.addEventListener('pointerleave', () => { paused = false; schedule(); });
  track.addEventListener('pointerup', () => { paused = track.matches(':hover, :focus-within'); schedule(); });
  track.addEventListener('focusin', pause);
  track.addEventListener('focusout', event => { if (!track.contains(event.relatedTarget)) { paused = false; schedule(); } });
  document.addEventListener('visibilitychange', () => { cancelAnimationFrame(frame); busy = false; schedule(); });
  motion.addEventListener('change', () => { cancelAnimationFrame(frame); busy = false; schedule(); });
  schedule();
})();
