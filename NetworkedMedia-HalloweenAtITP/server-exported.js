var servi = require('servi');

var app = new servi(true);


serveFiles("halloweenatitp");


if (typeof run === 'function') {
  app.defaultRoute(run);
}
start();