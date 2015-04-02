var servi = require('servi');

var app = new servi(true);


serveFiles("memorygame");


if (typeof run === 'function') {
  app.defaultRoute(run);
}
start();