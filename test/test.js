var request = require('request');
var assert = require('assert');
var http = require('http');
var app = require('../app');
var database = require('../database');
var origin = 'http://localhost:3000';
var testLinks = ['/', '/works', '/itemdata'];
var server = http.createServer(app);
server.listen('3000');

describe('App', function() {
  before(function(done) {
    this.timeout(20000);
    database.connectDb(function (err) {
      if (err) throw err;
      done();
    });
  });
  describe('Pages', function() {
    it(origin + '/' + ' returns status code 200', function(done) {
      request.get(origin, function(err, res, body) {
        if (err) throw err;
        console.log(err)
        console.log(body)
        assert.equal(200, res.statusCode);
        done();
      });
    });
  });
  after(function () {
    //server.close();
  });
});
