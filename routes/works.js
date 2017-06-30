var express = require('express');
var router = express.Router();
var fs = require('fs');
var data = JSON.parse(fs.readFileSync('routes/data.json', 'utf8'))
var links = data.navLinks

/* GET works page. */
router.get('/', function(req, res, next) {
  res.render('works', { 
    navLinks: links,
    pageContent: data.Projects,
    itemKeys: Object.keys(data.Projects)
  });
});

router.get('/:item', function(req, res, next) {
  res.render('item', {
    navLinks: links,
    pageContent: data.Projects,
    itemKeys: Object.keys(data.Projects),
    itemID: req.params.item
  }, function(err, page) {
    if (err) {
      console.log('error', err);
      if (req.params.item.replace(/[0-9]/g, '') === "item") {
        res.render('error', {
          error: err,
          type: "NotImplementedError"
        });
      }
      else {
        res.render('error', {
          error: err,
          type: "UndefinedPage"
        });
      }
    }
    else {
      res.end(page);
    }
  });
});

module.exports = router;
