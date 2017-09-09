express = require 'express'
router = express.Router()
database = require '../routes/database'
item = require '../routes/item'

router.post '/:method', (req, res, next) ->
  db = database.getDb()
  if req.params.method == 'new'
    console.log 'new'
    collection = new item.collection database.getId(), req.body.Name, req.body.Status, req.body.Type, req.body.Link, req.body.Description, req.body.Date, req.body.Technologies, req.body.Images
    db.collection('collection').insert(collection)
    db.collection('collection').find({}).toArray (err, result) ->
      console.log(result)
      #db.collection('item').remove()
  return
  
router.get '/', (req, res, next) ->
  database.getDb().collection('collection').find({}).toArray (err, result) ->
    res.render 'collectiondata',
      itemKeys: Object.keys(result)
      items: result
    return
  return


module.exports = router