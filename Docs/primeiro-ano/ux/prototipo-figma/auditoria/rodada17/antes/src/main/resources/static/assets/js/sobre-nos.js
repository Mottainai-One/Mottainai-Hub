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

// Cada ano tem viewport, track e índice próprios. Somente o track é transformado.
(() => {
  document.querySelectorAll('.carrossel-wrap').forEach(wrap => {
    const viewport=wrap.querySelector('.team-viewport'), track=wrap.querySelector('.team-track');
    const prev=wrap.querySelector('.team-arrow-prev'), next=wrap.querySelector('.team-arrow-next');
    if (!viewport || !track || !prev || !next) return;
    const cards=[...track.querySelectorAll('.cartoes')];
    let index=0, pointerStart=null;
    const metrics=()=>({step:cards.length>1 ? cards[1].offsetLeft-cards[0].offsetLeft : track.clientWidth,max:Math.max(0,track.scrollWidth-track.clientWidth)});
    const apply=()=>{
      const {step,max}=metrics();
      index=Math.min(index,step ? Math.ceil(max/step) : 0);
      const offset=Math.min(index*step,max);
      track.style.transform=`translate3d(${-offset}px,0,0)`;
      track.dataset.index=String(index);
      prev.hidden=offset<=1;
      next.hidden=max<=1 || offset>=max-1;
    };
    const move=direction=>{const {step,max}=metrics();index=Math.max(0,Math.min(index+direction,step ? Math.ceil(max/step) : 0));apply();};
    prev.addEventListener('click',()=>move(-1));next.addEventListener('click',()=>move(1));
    viewport.addEventListener('keydown',event=>{
      if (!['ArrowLeft','ArrowRight','Home','End'].includes(event.key)) return;
      event.preventDefault();
      if(event.key==='Home'){index=0;apply();}
      else if(event.key==='End'){const {step,max}=metrics();index=step ? Math.ceil(max/step) : 0;apply();}
      else move(event.key==='ArrowRight'?1:-1);
    });
    viewport.addEventListener('pointerdown',event=>{pointerStart=event.clientX;viewport.setPointerCapture(event.pointerId);});
    viewport.addEventListener('pointerup',event=>{if(pointerStart!==null && Math.abs(event.clientX-pointerStart)>44)move(event.clientX<pointerStart?1:-1);pointerStart=null;});
    viewport.addEventListener('pointercancel',()=>{pointerStart=null;});
    window.addEventListener('resize',apply);
    track.querySelectorAll('img').forEach(img=>img.addEventListener('load',apply));
    apply();
  });
})();
