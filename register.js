let pwScore = 0; // track current password strength score

function toggleEye(fieldId, iconId) {
  const input = document.getElementById(fieldId);
  const icon  = document.getElementById(iconId);
  if (input.type === 'password') {
    input.type = 'text';
    icon.textContent = '🙈';
  } else {
    input.type = 'password';
    icon.textContent = '👁️';
  }
}

function checkStrength(val) {
  const wrap  = document.getElementById('strengthWrap');
  const fill  = document.getElementById('strengthFill');
  const label = document.getElementById('strengthLabel');
  const err   = document.getElementById('pwError');

  if (!val) { wrap.classList.remove('show'); pwScore = 0; return; }
  wrap.classList.add('show');

  pwScore = 0;
  if (val.length >= 8)              pwScore++;
  if (/[A-Z]/.test(val))            pwScore++;
  if (/[0-9]/.test(val))            pwScore++;
  if (/[^A-Za-z0-9]/.test(val))    pwScore++;

  const levels = [
    { pct:'20%', color:'#ff4444', text:'Too weak'  },
    { pct:'45%', color:'#ffaa00', text:'Weak'      },
    { pct:'68%', color:'#ffdd00', text:'Fair'      },
    { pct:'85%', color:'#88dd00', text:'Strong'    },
    { pct:'100%',color:'#00ff99', text:'Very strong'},
  ];

  const l = levels[pwScore];
  fill.style.width      = l.pct;
  fill.style.background = l.color;
  label.textContent     = l.text;
  label.style.color     = l.color;

  // Hide error once password becomes strong enough
  if (pwScore >= 3) err.style.display = 'none';
}

function validateForm() {
  const err = document.getElementById('pwError');
  if (pwScore < 3) {
    err.style.display = 'block';
    document.getElementById('password').focus();
    return false; // block form submission
  }
  return true; // allow submission
}
