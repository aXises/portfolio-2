var request = require('request');
var assert = require('assert');
var http = require('http');
var app = require('../app');
var database = require('../routes/database');
var origin = 'http://localhost:3000';
var testLinks = ['/', '/itemdata', '/collectiondata', '/teamdata', '/portfolio'];

describe('App', function() {
  before(function(done) {
    this.timeout(20000);
    database.connectDb(function (err) {
      if (err) throw err;
      var server = http.createServer(app);
      server.listen('3000');
      done();
    });
  });
  describe('MongoDB', function() {
    describe('Database connection', function() {
      it('Connects to Mongo Atlas', function(done) {
        assert.ok(database.getDb().serverConfig.isConnected());
        done();
      });
    });
  });
  describe('Pages', function() {
    for (var i = 0; i < testLinks.length; i++) {
      var page = origin + testLinks[i];
      testPages(page);
    }
  });
});

function testPages(page) {
  it(page + ' returns status code 200', function(done) {
    this.timeout(5000);
    request.get(page, function(err, res) {
      assert.equal(200, res.statusCode);
      done();
    });
  });
}
