var request = require("request");
var assert = require('assert');
var origin = "http://localhost:3000/"
var http = require('http');
var app = require('../app');

var server = http.createServer(app);
server.listen("3000");

describe("App", function() {
  describe("GET /", function() {
    it("returns status code 200", function(done) {
      request.get(origin, function(err, res) {
        assert.equal(200, res.statusCode);
        server.close();
        done();
      });
    });
  });
});