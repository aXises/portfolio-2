express = require 'express'
router = express.Router()
database = require '../routes/database'
db = null

convertToArrayIfNot = (field) ->
  if typeof(field) != 'object' then return [field] else return field

getDelta = (arr1, arr2) ->
  res = arr1.filter((x) => arr2.indexOf(x) == -1)
  if !(res[0]) then return null else return res

router.post '/new', (req, res, next) ->
  req.body._id = database.getId()
  showcase = req.body.showcase == 'true'
  req.body.itemType = 'item'
  db.insertOne(req.body).then () ->
    if showcase
      database.generateShowcase 'items', req.params.id, req.body
    res.redirect 'back'

router.post '/getData', (req, res, next) ->
  database.getDb().collection('item').findOne({'_id': database.getId req.body.id}).then (result) ->
    res.send result

router.post '/delete', (req, res, next) ->
  db.deleteOne({'_id': database.getId req.body.id}).then () ->
    res.send true

router.post '/update/:id', (req, res, next) ->
  showcase = req.body.showcase == 'true'
  db.updateOne(
    {'_id': database.getId req.params.id},
    {$set: req.body}
  ).then () ->
    if showcase
      database.generateShowcase 'items', req.params.id, req.body
    res.redirect 'back'

router.get '/', (req, res, next) ->
  if express().get('env') == 'development'
    db = database.getDb().collection('item')
    db.find({}).toArray (err, items) ->
      database.getDb().collection('collection').find({}).toArray (err, collections) ->
        res.render 'itemdata',
          itemKeys: Object.keys items
          items: items
          collectionKeys: Object.keys collections
          collections: collections

module.exports = router