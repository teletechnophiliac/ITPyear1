var servi = require('servi');

var app = new servi(true);


serveFiles("imdbjson");


if (typeof run === 'function') {
  app.defaultRoute(run);
}
start();