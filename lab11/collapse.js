(function() {
    'use strict';
    document.addEventListener('click', function(event) {
      if ((event.target.id === 'item-1') || (event.target.id === 'item-2')) {
        event.target.parentElement.parentElement.nextElementSibling.style.display = 'None';
      }
    })
}());
