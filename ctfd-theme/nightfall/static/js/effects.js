(function () {
  var reduce = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  /* ---------- Boot screen (once per browser session) ---------- */
  function boot() {
    try { if (sessionStorage.getItem('nf_boot')) return; sessionStorage.setItem('nf_boot', '1'); } catch (e) {}
    if (reduce) return;

    var lines = [
      '<span class="hi">&gt;</span> initializing secure session...',
      '<span class="ok">[ OK ]</span> loading kernel modules',
      '<span class="ok">[ OK ]</span> mounting evidence vault',
      '<span class="ok">[ OK ]</span> starting incident review portal',
      '<span class="ok">[ OK ]</span> establishing analyst gateway',
      '<span class="hi">&gt; ACCESS LEVEL: ANALYST</span>',
      '<span class="hi">&gt; WELCOME TO OPERATION NIGHTFALL</span>'
    ];

    var b = document.createElement('div');
    b.id = 'nf-boot';
    b.innerHTML = '<div class="nf-boot-box">' +
      '<div class="nf-boot-title">CYGNUS LABS SOC // BOOT SEQUENCE</div>' +
      '<div class="nf-boot-log"></div>' +
      '<div class="nf-boot-bar"><div class="nf-boot-fill"></div></div>' +
      '<div class="nf-boot-skip">CLICK OR PRESS ANY KEY TO SKIP</div></div>';
    document.body.appendChild(b);

    var log = b.querySelector('.nf-boot-log');
    var fill = b.querySelector('.nf-boot-fill');
    var i = 0, done = false, timer;

    function finish() {
      if (done) return; done = true;
      clearInterval(timer);
      b.classList.add('nf-out');
      setTimeout(function () { b.remove(); }, 600);
      document.removeEventListener('keydown', finish);
    }

    timer = setInterval(function () {
      if (i < lines.length) {
        var d = document.createElement('div');
        d.innerHTML = lines[i];
        log.appendChild(d);
        i++;
        fill.style.width = (i / lines.length * 100) + '%';
      } else {
        setTimeout(finish, 350);
        clearInterval(timer);
      }
    }, 280);

    b.addEventListener('click', finish);
    document.addEventListener('keydown', finish);
  }

  /* ---------- Live scoreboard box (home page only) ---------- */
  function board() {
    var box = document.getElementById('nf-board');
    if (!box) return;

    box.innerHTML = '';
    var h = document.createElement('h3');
    var t = document.createElement('span'); t.textContent = 'Top Analysts';
    var l = document.createElement('span'); l.className = 'nf-live'; l.textContent = 'LIVE';
    h.appendChild(t); h.appendChild(l);
    var list = document.createElement('div');
    box.appendChild(h); box.appendChild(list);

    function render(rows) {
      list.innerHTML = '';
      if (!rows.length) {
        var e = document.createElement('div');
        e.className = 'nf-empty'; e.textContent = 'No scores yet. Be the first.';
        list.appendChild(e); return;
      }
      rows.slice(0, 5).forEach(function (r, idx) {
        var row = document.createElement('div'); row.className = 'nf-row';
        row.style.animationDelay = (idx * 0.06) + 's';
        var a = document.createElement('span'); a.className = 'nf-rank'; a.textContent = '#' + (idx + 1);
        var n = document.createElement('span'); n.textContent = r.name;
        var s = document.createElement('span'); s.className = 'nf-score'; s.textContent = r.score + ' PTS';
        row.appendChild(a); row.appendChild(n); row.appendChild(s);
        list.appendChild(row);
      });
    }

    function load() {
      fetch('/api/v1/scoreboard', { credentials: 'same-origin' })
        .then(function (r) { return r.ok ? r.json() : null; })
        .then(function (j) {
          if (j && j.data) render(j.data);
else { list.innerHTML = ''; var e = document.createElement('div'); e.className = 'nf-empty'; e.textContent = 'Scoreboard unavailable.'; list.appendChild(e); }
        })
        .catch(function () {});
    }
    load();
    setInterval(load, 10000);
  }

  document.addEventListener('DOMContentLoaded', function () {
    boot();
    board();
  });
})();
