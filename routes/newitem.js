var express = require('express');
var router = express.Router();
var jade = require('jade');
var database = require('../database');

router.post('/', function(req, res, next) {
    console.log(req.method)
    var keys = Object.keys(req.body)
    for (var i = 0; i < keys.length; i++) {
      // console.log(keys[i], req.body[keys[i]])
      var value = req.body[keys[i]]
    }
    //console.log(req.body)
    database.getCollection('data', function(data) {
      console.log('current data size', Object.keys(data.Projects).length)
      var itemSize = Object.keys(data.Projects).length
      var projects = [data.Projects]
      var item = {}
      item['ITEM'+(itemSize+1)] = req.body
      projects.push(item)
      console.log(projects)
    });

    return false;
});

router.get('/', function(req, res, next) {
  database.getCollection('data', function(data) {
    res.render('newitem', { 
      itemKeys: Object.keys(data.Projects),
      template: data.Templates["Project"],
      templateKeys: Object.keys(data.Templates["Project"])
    });
  });
});

module.exports = router;