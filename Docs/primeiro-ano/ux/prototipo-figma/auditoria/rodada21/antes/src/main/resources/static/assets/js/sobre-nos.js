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

// Rodada 17 — faixa circular: cópias visuais nas bordas, originais preservados no centro.
(() => {
  document.querySelectorAll('.carrossel-wrap').forEach(wrap => {
    const viewport=wrap.querySelector('.team-viewport'), track=wrap.querySelector('.team-track');
    const prev=wrap.querySelector('.team-arrow-prev'), next=wrap.querySelector('.team-arrow-next');
    if (!viewport || !track || !prev || !next) return;
    const cards=[...track.querySelectorAll('.cartoes')], count=cards.length;
    if (!count) return;
    const reduced=matchMedia('(prefers-reduced-motion:reduce)');
    const copy=card=>{const clone=card.cloneNode(true);clone.dataset.teamClone='true';clone.setAttribute('aria-hidden','true');clone.setAttribute('inert','');clone.removeAttribute('id');clone.querySelectorAll('[id]').forEach(e=>e.removeAttribute('id'));return clone;};
    track.prepend(...cards.map(copy));track.append(...cards.map(copy));
    let index=count, moving=false, pending=0, pointerStart=null, fallback;
    const metrics=()=>({step:count>1 ? cards[1].offsetLeft-cards[0].offsetLeft : cards[0].offsetWidth,gap:parseFloat(getComputedStyle(track).columnGap)||0});
    const logical=()=>((index-count)%count+count)%count;
    const paint=()=>{track.style.transform=`translate3d(${-index*metrics().step}px,0,0)`;track.dataset.index=String(logical());};
    const reset=()=>{
      track.setAttribute('data-reset','');paint();
      void track.offsetWidth;
      requestAnimationFrame(()=>requestAnimationFrame(()=>track.removeAttribute('data-reset')));
    };
    const controls=()=>{
      const {step,gap}=metrics();wrap.style.setProperty('--team-gap',gap+'px');
      const w=wrap.getBoundingClientRect(),v=viewport.getBoundingClientRect(),zoom=w.width/wrap.offsetWidth || 1;
      const style=getComputedStyle(viewport),photo=cards[0].querySelector('img');
      const left=(v.left-w.left)/zoom+parseFloat(style.paddingLeft)+cards[0].offsetWidth*.42;
      const right=(v.right-w.left)/zoom-parseFloat(style.paddingRight)-cards[0].offsetWidth*.42;
      const top=(v.top-w.top)/zoom+parseFloat(style.paddingTop)+(photo?.offsetHeight||266)*.59;
      wrap.style.setProperty('--team-control-size',(Math.min(96,Math.max(44,innerWidth/15))/zoom)+'px');
      wrap.style.setProperty('--team-arrow-left',left+'px');wrap.style.setProperty('--team-arrow-right',right+'px');wrap.style.setProperty('--team-arrow-top',top+'px');
      const fits=count*step-gap<=track.clientWidth+1;prev.hidden=fits;next.hidden=fits;
    };
    const finish=()=>{
      if (!moving) return;
      clearTimeout(fallback);moving=false;
      if(index<count || index>=2*count){index=count+logical();reset();}
      if(pending){const direction=pending;pending=0;requestAnimationFrame(()=>requestAnimationFrame(()=>move(direction)));}
    };
    const move=direction=>{
      if(moving){pending=direction;return;}
      track.removeAttribute('data-reset');index+=direction;moving=true;paint();
      if(reduced.matches)finish();else fallback=setTimeout(finish,900);
    };
    const layout=()=>{clearTimeout(fallback);moving=false;pending=0;index=count+logical();controls();reset();};
    track.addEventListener('transitionend',event=>{if(event.target===track && event.propertyName==='transform')finish();});
    prev.addEventListener('click',()=>move(-1));next.addEventListener('click',()=>move(1));
    viewport.addEventListener('keydown',event=>{
      if(!['ArrowLeft','ArrowRight','Home','End'].includes(event.key))return;
      event.preventDefault();
      if(event.key==='Home'||event.key==='End'){index=count+(event.key==='End'?count-1:0);pending=0;moving=false;clearTimeout(fallback);paint();}
      else move(event.key==='ArrowRight'?1:-1);
    });
    viewport.addEventListener('pointerdown',event=>{pointerStart=event.clientX;viewport.setPointerCapture(event.pointerId);});
    viewport.addEventListener('pointerup',event=>{if(pointerStart!==null && Math.abs(event.clientX-pointerStart)>44)move(event.clientX<pointerStart?1:-1);pointerStart=null;});
    viewport.addEventListener('pointercancel',()=>{pointerStart=null;});
    window.addEventListener('resize',layout);reduced.addEventListener('change',layout);
    cards.forEach(card=>card.querySelectorAll('img').forEach(img=>img.addEventListener('load',controls)));
    layout();
  });
})();
