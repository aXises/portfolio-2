express = require 'express'
router = express.Router()

router.get '/', (req, res, next) ->
  res.render 'designblogs', {
  }
  
module.exports = router