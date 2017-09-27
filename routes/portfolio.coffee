express = require 'express'
router = express.Router()
database = require '../routes/database'

router.get '/', (req, res, next) ->
  res.render 'portfolio', {
    title: 'AXISIO'
  }

module.exports = router