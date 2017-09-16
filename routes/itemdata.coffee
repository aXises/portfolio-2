express = require 'express'
router = express.Router()
database = require '../routes/database'
item = require '../routes/item'

router.post '/newItem', (req, res, next) ->
  db = database.getDb()
  newItem = new item.item database.getId(), req.body.name, req.body.status, req.body.type, req.body.link, req.body.description, req.body.date, req.body.technologies, req.body.images
  db.collection('collection').find({'_id':database.getId(req.body.collection)}).toArray (err, result) ->
    currentCollection = new item.collection result[0]._id, result[0].name, result[0].status, result[0].type, result[0].link, result[0].description, result[0].image, result[0].hasItems
    newItem.setCollection currentCollection
    db.collection('collection').update {'_id':database.getId(req.body.collection)}, currentCollection
    db.collection('item').insert newItem, ->
      res.redirect 'back'

router.post '/newCollection', (req, res, next) ->
  db = database.getDb()
  newCollection = new item.collection database.getId(), req.body.name, req.body.status, req.body.type, req.body.link, req.body.description, req.body.image, req.body.items, req.body.showcase
  db.collection('collection').insert newCollection, ->
    res.redirect 'back'

router.post '/getItem', (req, res, next) ->
  db = database.getDb()
  db.collection('item').find({'_id':database.getId(req.body.id)}).toArray (err, result) ->
    res.send(result[0])

router.post '/updateItem/:id', (req, res, next) ->
  db = database.getDb()
  db.collection('item').find({'_id':database.getId(req.params.id)}).toArray (err, result) ->
    editedItem = new item.item database.getId(req.params.id), req.body.name, req.body.status, req.body.type, req.body.link, req.body.description, req.body.date, req.body.technologies, req.body.images
    db.collection('item').update {'_id':database.getId(req.params.id)}, editedItem, ->
      res.redirect 'back'

router.post '/deleteItem', (req, res, next) ->
  db = database.getDb()
  db.collection('item').find({'_id':database.getId(req.body.id)}).toArray (err, result) ->
    if result[0].collection[0]

      itemId = req.body.id
      db.collection('collection').find({'_id':database.getId(result[0].collection[0])}).toArray (err, result) ->
        updatedItemList = []
        for id in result[0].hasItems
          if itemId != String(id)
            updatedItemList.push(id)
        currentCollection = new item.collection result[0]._id, result[0].name, result[0].status, result[0].type, result[0].link, result[0].description, result[0].image, updatedItemList
        db.collection('collection').update {'_id':database.getId(result[0]._id)}, currentCollection, ->
          db.collection('item').remove {'_id':database.getId(req.body.id)}, ->
            res.redirect('back')
    else
      db.collection('item').remove {'_id':database.getId(req.body.id)}, ->
        res.redirect 'back'

router.post '/deleteCollection', (req, res, next) ->
  db = database.getDb()
  db.collection('collection').find({'_id':database.getId(req.body.id)}).toArray (err, result) ->
    if result[0].hasItems.length > 0
      for itemIds in result[0].hasItems
        db.collection('item').find({'_id':database.getId(itemIds)}).toArray (err, result) ->
          console.log result[0]
          currentItem = new item.item result[0]._id, result[0].name, result[0].status, result[0].type, result[0].link, result[0].description, result[0].date, result[0].technologies, result[0].images
          db.collection('item').update {'_id':database.getId(result[0]._id)}, currentItem
      db.collection('collection').remove {'_id':database.getId(req.body.id)}, ->
        res.redirect 'back'
    else
      db.collection('collection').remove {'_id':database.getId(req.body.id)}, ->
        res.redirect 'back'

router.get '/', (req, res, next) ->
  database.getDb().collection('item').find({}).toArray (err, items) ->
    database.getDb().collection('collection').find({}).toArray (err, collections) ->
      res.render 'itemdata',
        itemKeys: Object.keys items
        items: items
        collectionKeys: Object.keys collections
        collections: collections

module.exports = router