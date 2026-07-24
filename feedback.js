function toggleDrawback(){
    let value = document.getElementById('drawback').value;
    let box = document.getElementById('drawbackText');

    if(value === 'Yes'){
        box.style.display = 'block';
    } else {
        box.style.display = 'none';
    }
}

// Decorative particles only — no logic
const c = document.getElementById('pts');
for (let i = 0; i < 22; i++) {
  const p = document.createElement('div');
  p.className = 'pt';
  const sz = Math.random() > .7 ? 3 : 2;
  p.style.cssText = `
    left:${Math.random()*100}%;
    width:${sz}px; height:${sz}px;
    --d:${8+Math.random()*10}s;
    --dl:${Math.random()*9}s;
    --dx:${(Math.random()-.5)*70}px;
  `;
  c.appendChild(p);
}
