var express = require('express');
var router = express.Router();
var jade = require('jade');
var database = require('../database');

router.get('/', function(req, res, next) {
  database.getCollection('data', function(data) {
    res.render('newitem', { 
      pageContent: data.Projects,
      itemKeys: Object.keys(data.Projects)
    });
  });
});

module.exports = router;