express = require 'express'
router = express.Router()
database = require '../routes/database'
item = require '../routes/item'

router.get '/', (req, res, next) ->
  db = database.getDb()
  res.render 'index', {
    title: 'AXISIO'
  }

module.exports = router