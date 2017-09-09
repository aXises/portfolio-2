express = require 'express'
router = express.Router()
database = require '../routes/database'
item = require '../routes/item'

router.post '/new', (req, res, next) ->
  db = database.getDb()
  currentItem = new item.item database.getId(), req.body.Name, req.body.Status, req.body.Type, req.body.Link, req.body.Description, req.body.Date, req.body.Technologies, req.body.Images
  if typeof(req.body.collection) == 'object'
    for id in req.body.collection
      db.collection('collection').find({'_id':database.getId(id)}).toArray (err, result) ->
        console.log(result)
        result[0].hasItems.push(currentItem._id)
  else
    db.collection('collection').find({'_id':database.getId(req.body.collection)}).toArray (err, result) ->
        #console.log(result)
        currentCollection = new item.collection result[0]._id, result[0].name, result[0].status, result[0].type, result[0].link, result[0].description, result[0].image, result[0].hasItems
        currentItem.setCollection(currentCollection)
        console.log(currentItem)
        console.log(currentCollection)
        #db.collection('item').insert(currentItem)
        #db.collection('collection').update({'_id':database.getId(req.body.collection)}, currentCollection)
  insert = (item, collection) ->
    db.collection('item').insert(item)
    db.collection('collection').insert(collection)
    return
  return

router.post '/getItem', (req, res, next) ->
  db = database.getDb()
  console.log 'getting', req.body.id
  db.collection('item').find({'_id':database.getId(req.body.id)}).toArray (err, result) ->
    #console.log result
    res.send(result[0])
    return
  return

router.post '/updateItem', (req, res, next) ->
  db = database.getDb()
  console.log 'editing'

router.get '/', (req, res, next) ->
  database.getDb().collection('item').find({}).toArray (err, items) ->
    database.getDb().collection('collection').find({}).toArray (err, collections) ->
      res.render 'itemdata',
        itemKeys: Object.keys(items)
        items: items
        collectionKeys: Object.keys(collections)
        collections: collections
      return
    return
  return


module.exports = router