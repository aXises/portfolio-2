var express = require('express');
var router = express.Router();
var fs = require('fs');
/* GET home page. */
router.get('/', function(req, res, next) {
  var data = JSON.parse(fs.readFileSync('routes/data.json', 'utf8'))
  var content = JSON.parse(fs.readFileSync('Nikku/resources/projects/portfolio-2/project.data/projects.json', 'utf8'))
  res.render('gallery', { 
    navLinks: data.navLinks,
    pageContent: content.Projects
  });
});

module.exports = router;