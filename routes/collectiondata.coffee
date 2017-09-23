express = require 'express'
router = express.Router()
database = require '../routes/database'
item = require '../routes/item'
  
router.get '/', (req, res, next) ->
  database.getDb().collection('collection').find({}).toArray (err, result) ->
    res.render 'collectiondata',
      itemKeys: Object.keys(result)
      items: result
    return
  return


module.exports = router