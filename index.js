// Detect touch device — disable custom cursor entirely
const isTouch = window.matchMedia('(pointer: coarse)').matches || 'ontouchstart' in window;

if (!isTouch) {
  const cur = document.getElementById('cursor');
  const ring = document.getElementById('cursorRing');
  let mx = 0, my = 0, rx = 0, ry = 0;
  document.addEventListener('mousemove', e => { mx = e.clientX; my = e.clientY; });
  function animCursor() {
    rx += (mx - rx) * 0.15;
    ry += (my - ry) * 0.15;
    cur.style.transform = `translate(${mx-5}px, ${my-5}px)`;
    ring.style.transform = `translate(${rx-18}px, ${ry-18}px)`;
    requestAnimationFrame(animCursor);
  }
  animCursor();
  document.querySelectorAll('a, button, .feat-card, .stat-cell, .step').forEach(el => {
    el.addEventListener('mouseenter', () => {
      ring.style.width = '54px'; ring.style.height = '54px';
      ring.style.opacity = '0.9';
    });
    el.addEventListener('mouseleave', () => {
      ring.style.width = '36px'; ring.style.height = '36px';
      ring.style.opacity = '0.6';
    });
  });
} else {
  document.getElementById('cursor').style.display = 'none';
  document.getElementById('cursorRing').style.display = 'none';
}

const reveals = document.querySelectorAll('.reveal');
const io = new IntersectionObserver((entries) => {
  entries.forEach((e, i) => {
    if (e.isIntersecting) {
      e.target.style.transitionDelay = (i % 4) * 0.1 + 's';
      e.target.classList.add('visible');
    }
  });
}, { threshold: 0.12 });
reveal
s.forEach(el => io.observe(el));
