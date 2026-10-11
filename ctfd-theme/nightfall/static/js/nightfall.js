(function () {
  var reduce = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  /* ---- Matrix rain background ---- */
  function startRain() {
    if (reduce) return;
    var c = document.createElement('canvas');
    c.id = 'nf-matrix';
    c.style.cssText = 'position:fixed;top:0;left:0;width:100%;height:100%;z-index:-1;opacity:.22;pointer-events:none';
    document.body.prepend(c);
    var ctx = c.getContext('2d');
    var size = 16, cols, drops;
    var chars = '0123456789ABCDEF<>/{}[]#$%&*+=';

    function resize() {
      c.width = window.innerWidth;
      c.height = window.innerHeight;
      cols = Math.floor(c.width / size);
      drops = [];
      for (var i = 0; i < cols; i++) drops[i] = Math.random() * -50;
    }
    resize();
    window.addEventListener('resize', resize);

    setInterval(function () {
      ctx.fillStyle = 'rgba(10,14,26,0.12)';
      ctx.fillRect(0, 0, c.width, c.height);
      ctx.fillStyle = '#00e5ff';
      ctx.font = size + 'px monospace';
      for (var i = 0; i < drops.length; i++) {
        var ch = chars.charAt(Math.floor(Math.random() * chars.length));
        ctx.fillText(ch, i * size, drops[i] * size);
        if (drops[i] * size > c.height && Math.random() > 0.975) drops[i] = 0;
        drops[i] += 0.6;
      }
    }, 60);
  }

  /* ---- Stagger challenge cards as CTFd loads them ---- */
  function stagger() {
    var seen = new WeakSet();
    function apply() {
      var items = document.querySelectorAll('.challenge-button');
      var n = 0;
      items.forEach(function (el) {
        if (seen.has(el)) return;
        seen.add(el);
        el.style.animationDelay = (n * 0.06) + 's';
        n++;
      });
    }
    apply();
    new MutationObserver(apply).observe(document.body, { childList: true, subtree: true });
  }

  document.addEventListener('DOMContentLoaded', function () {
    startRain();
    stagger();
  });
})();
