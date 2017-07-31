var request = require('request');
var assert = require('assert');
var http = require('http');
var app = require('../app');
var database = require('../database');
var origin = 'http://localhost:3000';
var testLinks = ['/', '/works'];

var server = http.createServer(app);
server.listen('3000');

before(function(done) {
  this.timeout(20000);
  database.connectDb(function () {
    var db = database.getDb()
    describe('MongoDB', function() {
      describe('Database connection', function() {
        it('Connects to Mongo Atlas', function(done) {
          assert.ok(db.serverConfig.isConnected());
          done();
        });
      });
    });
    done();
  });
});

describe('App', function() {
  describe('Pages', function() {
    for (var i = 0; i < testLinks.length; i++) {
      testPages(origin + testLinks[i])
    }
  });
});

after(function() {
  server.close();
});

function testPages(page) {
  it('returns status code 200', function(done) {
    request.get(page, function(err, res, body) {
      assert.equal(200, res.statusCode);
      done();
    });
  });
}