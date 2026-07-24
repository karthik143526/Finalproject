// Floating ⚠ particles — purely decorative
const syms = ['⚠', '!', '▲'];
const c = document.getElementById('pts');
for (let i = 0; i < 18; i++) {
  const p = document.createElement('div');
  p.className = 'pt';
  p.textContent = syms[Math.floor(Math.random() * syms.length)];
  p.style.cssText = `
    left:${Math.random() * 100}%;
    top:100%;
    --fs:${8 + Math.random() * 8}px;
    --d:${10 + Math.random() * 12}s;
    --dl:${Math.random() * 10}s;
    --r:${(Math.random() > .5 ? '' : '-')}${90 + Math.floor(Math.random()*270)}deg;
  `;
  c.appendChild(p);
}
