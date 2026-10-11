(function () {
  var SOUND = false;   /* set to true for a short beep on wrong/correct */
  var wrong = 0, audio;

  function beep(freq, dur) {
    if (!SOUND) return;
    try {
      audio = audio || new (window.AudioContext || window.webkitAudioContext)();
      var o = audio.createOscillator(), g = audio.createGain();
      o.type = 'square'; o.frequency.value = freq; g.gain.value = 0.05;
      o.connect(g); g.connect(audio.destination);
      o.start(); o.stop(audio.currentTime + dur);
    } catch (e) {}
  }

  function overlay(cls, title, sub) {
    var old = document.getElementById('nf-alarm');
    if (old) old.remove();
    var d = document.createElement('div');
    d.id = 'nf-alarm'; d.className = cls;
    d.innerHTML = '<div><div class="nf-alarm-title">' + title + '</div><div class="nf-alarm-sub">' + sub + '</div></div>';
    document.body.appendChild(d);
    setTimeout(function () { d.remove(); }, 1600);
  }

  function shake() {
    var h = document.documentElement;
    h.classList.remove('nf-shake');
    void h.offsetWidth;
    h.classList.add('nf-shake');
    setTimeout(function () { h.classList.remove('nf-shake'); }, 700);
  }

  function onResult(status) {
    if (status === 'incorrect') {
      wrong++; shake();
      overlay('nf-bad', 'ACCESS DENIED', 'WRONG FLAG // ATTEMPT ' + wrong);
      beep(160, 0.35);
    } else if (status === 'correct') {
      wrong = 0;
      overlay('nf-good', 'ACCESS GRANTED', 'FLAG ACCEPTED');
      beep(880, 0.15);
    } else if (status === 'ratelimited') {
      shake();
      overlay('nf-bad', 'SYSTEM LOCKED', 'TOO MANY ATTEMPTS // WAIT');
    }
  }

  var orig = window.fetch;
  window.fetch = function (input) {
    var url = (typeof input === 'string') ? input : ((input && input.url) || '');
    var p = orig.apply(this, arguments);
    if (url.indexOf('/api/v1/challenges/attempt') !== -1 && url.indexOf('preview') === -1) {
      p.then(function (r) { return r.clone().json(); })
       .then(function (j) { if (j && j.data) onResult(j.data.status); })
       .catch(function () {});
    }
    return p;
  };
})();
