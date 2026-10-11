(function () {
  var TOTAL = 6; var KEY = String((window.init && window.init.userId) || 'x');

  function solvedSet() {
    return fetch('/api/v1/users/me/solves', { credentials: 'same-origin' })
      .then(function (r) { return r.ok ? r.json() : null; })
      .then(function (j) {
        var s = {};
        if (!j || !j.data) return s;
        j.data.forEach(function (x) {
          var name = (x.challenge && x.challenge.name) || '';
          var m = name.match(/^NF\s*0?([1-6])\b/i);
          if (m) s[m[1]] = true;
        });
        return s;
      })
      .catch(function () { return {}; });
  }

  function confetti() {
    var c = document.createElement('canvas');
    c.id = 'nf-confetti';
    document.body.appendChild(c);
    var ctx = c.getContext('2d');
    c.width = innerWidth; c.height = innerHeight;
    var colors = ['#00e5ff', '#22c55e', '#e5e7eb', '#67e8f9'];
    var bits = [];
    for (var i = 0; i < 160; i++) bits.push({
      x: Math.random() * c.width, y: Math.random() * -c.height,
      w: 6 + Math.random() * 6, h: 10 + Math.random() * 8,
      vy: 2 + Math.random() * 4, vx: -1 + Math.random() * 2,
      col: colors[Math.floor(Math.random() * colors.length)]
    });
    var t = setInterval(function () {
      ctx.clearRect(0, 0, c.width, c.height);
      bits.forEach(function (b) {
        b.x += b.vx; b.y += b.vy;
        ctx.fillStyle = b.col; ctx.fillRect(b.x, b.y, b.w, b.h);
      });
    }, 20);
    setTimeout(function () { clearInterval(t); c.remove(); }, 6000);
  }

  function showCongrats() {
    if (document.getElementById('nf-overlay')) return;
    var o = document.createElement('div');
    o.className = 'nf-overlay'; o.id = 'nf-overlay';
    o.innerHTML =
      '<div class="nf-card">' +
      '<div class="nf-tag">[ MISSION COMPLETE ]</div>' +
      '<h2>Congratulations, Analyst</h2>' +
      '<p>You traced the intrusion from the first footprint to the root of the breach. ' +
      'All six NIGHTFALL challenges are solved and Cygnus Labs is secure again.</p>' +
      '<p style="color:#22c55e">6 / 6 challenges completed</p>' +
      '<button class="nf-close">CLOSE</button></div>';
    document.body.appendChild(o);
    o.querySelector('.nf-close').onclick = function () { o.remove(); };
    confetti();
  }

  function challengesPage() {
    var jumbo = document.querySelector('.jumbotron');
    if (!jumbo) return;
    var box = document.createElement('div');
    box.className = 'nf-progress';
    box.innerHTML = '<div class="nf-ptop"><span>MISSION PROGRESS</span><span><b id="nf-count">0</b> / ' + TOTAL +
      ' SOLVED</span></div><div class="nf-bar"><div class="nf-fill" id="nf-fill"></div></div>';
    jumbo.parentNode.insertBefore(box, jumbo.nextSibling);

    function update() {
      solvedSet().then(function (s) {
        var n = Object.keys(s).length;
        document.getElementById('nf-count').textContent = n;
        document.getElementById('nf-fill').style.width = (n / TOTAL * 100) + '%';
        if (n >= TOTAL && !localStorage.getItem('nf_congrats_' + KEY)) {
          localStorage.setItem('nf_congrats_' + KEY, '1');
          showCongrats();
        }
      });
    }
    update();
    setInterval(update, 4000);
  }

  function homePage() {
    var banner = document.getElementById('nf-done');
    if (!banner) return;
    solvedSet().then(function (s) {
      if (Object.keys(s).length >= TOTAL) {
        banner.style.display = 'block';
        banner.innerHTML = '[ MISSION COMPLETE ] ALL 6 CHALLENGES SOLVED. WELL DONE, ANALYST.';
      }
    });
  }

  document.addEventListener('DOMContentLoaded', function () {
    if (location.pathname.indexOf('/challenges') === 0) challengesPage();
    homePage();
  });
})();

