var system = require('system');
var args = system.args;

var page = require('webpage').create();
page.viewportSize = { width: 800, height: 600 };
//page.clipRect = { top: 0, left: 0, width: 800, height: 600 };
page.open('http://'+args[1], function() {
  page.render(args[1]+'.png');
  phantom.exit();
});
