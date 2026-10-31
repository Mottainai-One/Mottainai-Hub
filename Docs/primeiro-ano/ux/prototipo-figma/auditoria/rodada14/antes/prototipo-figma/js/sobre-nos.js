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
