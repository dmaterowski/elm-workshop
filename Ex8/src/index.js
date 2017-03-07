'use strict';

require('./index.html');
require('./index.less');
require('bootstrap-webpack!../bootstrap.config.js');


var Elm = require('./Main');

var userData = JSON.parse(localStorage.getItem('userData'));
console.log(userData);

var app = Elm.Main.embed(document.getElementById('main'),{userData: userData});

app.ports.saveUser.subscribe(function(userData){
  console.log('userData')
  localStorage.setItem('userData', JSON.stringify(userData));
})