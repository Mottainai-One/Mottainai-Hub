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

// Cada grupo da equipe controla sua própria rolagem e seus limites.
(() => {
  document.querySelectorAll('.carrossel-wrap').forEach(wrap => {
    const track=wrap.querySelector('.carrossel');
    const prev=wrap.querySelector('.team-arrow-prev'),next=wrap.querySelector('.team-arrow-next');
    if(!track || !prev || !next) return;
    const update=()=>{const max=track.scrollWidth-track.clientWidth,style=getComputedStyle(track),edge=Math.max(parseFloat(style.paddingLeft)||0,parseFloat(style.paddingRight)||0)+2;prev.hidden=track.scrollLeft<=edge;next.hidden=max<=edge || track.scrollLeft>=max-edge;};
    const move=direction=>track.scrollBy({left:direction*track.clientWidth,behavior:matchMedia('(prefers-reduced-motion:reduce)').matches?'instant':'smooth'});
    prev.addEventListener('click',()=>move(-1));next.addEventListener('click',()=>move(1));
    track.addEventListener('scroll',update,{passive:true});window.addEventListener('resize',update);
    track.querySelectorAll('img').forEach(img=>img.addEventListener('load',update));
    update();requestAnimationFrame(update);
  });
})();
