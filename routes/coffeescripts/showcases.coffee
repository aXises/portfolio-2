express = require 'express'
router = express.Router()

router.get '/:itemType/:id', (req, res, next) ->
  res.render 'showcases/' + req.params.itemType + 's/' + req.params.id + '/index', {
    id: req.params.id
  }
  
module.exports = router