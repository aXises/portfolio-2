express = require 'express'
router = express.Router()
database = require '../routes/database'

router.get '/', (req, res, next) ->
  database.getDb().collection('collection').find({
    featured: 'true'
  }).toArray (err, result) ->
    res.render 'portfolio', {
      title: 'AXISIO'
      selectedCollections: result
    }

module.exports = router