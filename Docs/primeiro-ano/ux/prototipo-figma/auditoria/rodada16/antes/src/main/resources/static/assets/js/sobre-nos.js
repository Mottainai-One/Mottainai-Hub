// A V7 já usa radios, um track e transform .6s ease. Auto/manual compartilham goToSlide.
(() => {
  const carousel = document.querySelector('.hero-carrossel');
  if (!carousel) return;
  const radios = [...carousel.querySelectorAll('.hero-radio')];
  const dots = [...carousel.querySelectorAll('.car-dots button')];
  const reducedMotion = matchMedia('(prefers-reduced-motion: reduce)');
  const interval = parseFloat(getComputedStyle(carousel).getPropertyValue('--tempo')) * 1000 || 7000;
  let current = 0, timer;
  function goToSlide(index) {
    current = (index + radios.length) % radios.length;
    radios[current].checked = true;
    dots.forEach((dot, i) => dot.setAttribute('aria-pressed', String(i === current)));
    carousel.dataset.slide = String(current);
  }
  function stop() { clearInterval(timer); }
  function start() {
    stop();
    if (!document.hidden && !reducedMotion.matches && !carousel.matches(':hover, :focus-within')) {
      timer = setInterval(() => goToSlide(current + 1), interval);
    }
  }
  carousel.dataset.enhanced = 'true';
  goToSlide(0);
  const openAnchor = () => {
    const index = [...carousel.querySelectorAll('.slide')].findIndex(slide => '#'+slide.id === location.hash);
    if (index < 0) return;
    goToSlide(index);
    requestAnimationFrame(() => { carousel.scrollLeft=0; carousel.querySelector('.hero-track').scrollLeft=0; });
  };
  window.addEventListener('hashchange', openAnchor);
  openAnchor();
  carousel.querySelectorAll('[data-slide]').forEach(button => {
    button.addEventListener('click', () => { goToSlide(Number(button.dataset.slide)); start(); });
  });
  carousel.querySelectorAll('[data-direction]').forEach(button => {
    button.addEventListener('click', () => { goToSlide(current + Number(button.dataset.direction)); start(); });
  });
  radios.forEach((radio, i) => radio.addEventListener('change', () => { if (radio.checked) { goToSlide(i); start(); } }));
  carousel.addEventListener('keydown', event => {
    if (event.key !== 'ArrowLeft' && event.key !== 'ArrowRight') return;
    event.preventDefault(); goToSlide(current + (event.key === 'ArrowRight' ? 1 : -1)); start();
  });
  carousel.addEventListener('mouseenter', stop);
  carousel.addEventListener('mouseleave', start);
  carousel.addEventListener('focusin', stop);
  carousel.addEventListener('focusout', () => setTimeout(start, 0));
  document.addEventListener('visibilitychange', start);
  reducedMotion.addEventListener('change', start);
  start();
})();

// Cada clique desloca uma posição com movimento contínuo; os grupos são independentes.
(() => {
  document.querySelectorAll('.carrossel-wrap').forEach(wrap => {
    const track = wrap.querySelector('.carrossel');
    const prev = wrap.querySelector('.team-arrow-prev'), next = wrap.querySelector('.team-arrow-next');
    if (!track || !prev || !next) return;
    const reduced = matchMedia('(prefers-reduced-motion: reduce)');
    let frame = 0, destination = 0;
    const update = () => {
      const max = track.scrollWidth-track.clientWidth, style = getComputedStyle(track);
      const edge = Math.max(parseFloat(style.paddingLeft)||0,parseFloat(style.paddingRight)||0)+2;
      prev.hidden = track.scrollLeft <= edge;
      next.hidden = max <= edge || track.scrollLeft >= max-edge;
    };
    const stop = () => { cancelAnimationFrame(frame); frame=0; delete track.dataset.moving; update(); };
    const move = direction => {
      const card=track.querySelector('.cartoes');
      if (!card) return;
      const step=card.getBoundingClientRect().width+(parseFloat(getComputedStyle(track).columnGap)||0);
      const from=track.scrollLeft, max=track.scrollWidth-track.clientWidth;
      destination=Math.min(max,Math.max(0,(frame ? destination : from)+direction*step));
      cancelAnimationFrame(frame);
      if (reduced.matches) { track.scrollLeft=destination; stop(); return; }
      track.dataset.moving='true';
      const started=performance.now(), target=destination;
      const tick=now=>{
        const t=Math.min((now-started)/650,1), eased=t<.5 ? 4*t*t*t : 1-Math.pow(-2*t+2,3)/2;
        track.scrollLeft=from+(target-from)*eased;
        update();
        if (t<1) frame=requestAnimationFrame(tick);
        else { frame=0; delete track.dataset.moving; update(); }
      };
      frame=requestAnimationFrame(tick);
    };
    prev.addEventListener('click',()=>move(-1)); next.addEventListener('click',()=>move(1));
    track.addEventListener('scroll',update,{passive:true});
    track.addEventListener('pointerdown',stop,{passive:true}); track.addEventListener('wheel',stop,{passive:true});
    window.addEventListener('resize',stop);
    track.querySelectorAll('img').forEach(img=>img.addEventListener('load',update));
    update(); requestAnimationFrame(update);
  });
})();
