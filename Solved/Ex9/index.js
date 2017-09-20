"use strict";

var app = Elm.Ex9.embed(document.getElementById("main"), {
  name: "Me",
  email: "me@example.com"
});

app.ports.notifyJs.subscribe(function(word) {
  console.log(word);
});

app.ports.notifiedByJs.send("value");
