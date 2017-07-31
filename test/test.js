var request = require("request");
var assert = require('assert');
var origin = "http://localhost:3000/"
var http = require('http');
var app = require('../app');
var cheerio = require('cheerio');

var server = http.createServer(app);
server.listen("3000");

describe("App", function() {
  describe("GET /", function() {
    it("returns status code 200", function(done) {
      var links = getLinks(origin);

      server.close();
    });
  });
});

function getLinks(page) {
  request.get(page, function (err, res, body) {
    if (err) throw err;
    $ = cheerio.load(body);
    var links = $('nav a');
    var urls = [page];
    for (var i = 0; i < links.length; i++) {
      urls.push(page + $(links[i]).attr('href').substr(1));
    }
    return urls;
  });
}