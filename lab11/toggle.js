(function() {
   'use strict';
   // write your js here.
   const index = document.styleSheets.length - 1;
   const stylesheet = document.styleSheets[index];
   setInterval(function(){
        stylesheet.disabled = !stylesheet.disabled;
    }, 2000)
    
}());