function togglePassword(){
  let p=document.getElementById('password'),e=document.getElementById('eye');
  if(p.type==='password'){p.type='text';e.textContent='🙈';}
  else{p.type='password';e.textContent='👁️';}
}
let c=document.getElementById('c'),r=document.getElementById('r'),mx=0,my=0,rx=0,ry=0;
document.onmousemove=e=>{mx=e.clientX;my=e.clientY}
(function f(){rx+=(mx-rx)*.15;ry+=(my-ry)*.15;
c.style.transform=`translate(${mx-4}px,${my-4}px)`;
r.style.transform=`translate(${rx-15}px,${ry-15}px)`;
requestAnimationFrame(f)})();
