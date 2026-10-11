(function () {
  function tag() {
    var h = document.querySelector('.category-header');
    if (!h) return;
    var block = h.parentElement;                 /* one category */
    var board = block && block.parentElement;    /* holds all categories */
    if (board && !board.classList.contains('nf-grid-board')) {
      board.classList.add('nf-grid-board');
    }
  }
  document.addEventListener('DOMContentLoaded', function () {
    if (location.pathname.indexOf('/challenges') !== 0) return;
    tag();
    new MutationObserver(tag).observe(document.body, { childList: true, subtree: true });
  });
})();
