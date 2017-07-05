var express = require('express');
var router = express.Router();
var jade = require('jade');
var database = require('../database');

router.get('/', function(req, res, next) {
  database.getCollection('data', function(data) {
    res.render('newitem', { 
      itemKeys: Object.keys(data.Projects),
      templateKeys: Object.keys(data.Templates["Project"])
    });
  });
});

module.exports = router;