(function() {
   'use strict';
   var output = document.getElementById('output')
   
    setInterval(function() {
        var date = new Date();
        output.innerHTML = date.getHours() 
                + ':' + date.getMinutes()
                + ':' + date.getSeconds();
    }, 1000);

}());
