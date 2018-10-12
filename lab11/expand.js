(function() {
  'use strict';
  document.addEventListener('click', function(event) {
    if ((event.target.id === 'item-1') || (event.target.id === 'item-2')) {
      var content = event.target.parentElement.parentElement.nextElementSibling;
      var icon = event.target.firstChild;
      if  (content.style.display === 'none') {
        content.style.display = 'block';
        icon.data = 'expand_less';
      } else {
        content.style.display = 'none';
        icon.data = 'expand_more';
      }
   }
  });
}());
