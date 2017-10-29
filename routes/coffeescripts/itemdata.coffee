express = require 'express'
router = express.Router()
database = require '../routes/database'
db = null

convertToArrayIfNot = (arr) ->
  if typeof(arr) != 'object' then return [arr] else return arr

getDelta = (arr1, arr2) ->
  res = arr1.filter((x) => arr2.indexOf(x) == -1)
  if !(res[0]) then return null else return res

splitImgDesc = (arr) ->
  placeholdArr = []
  for arr in convertToArrayIfNot arr
    arr = arr.split ','
    if !arr[1] then arr[1] = ''
    placeholdArr.push [arr[0], arr[1]]
  return placeholdArr

router.post '/new', (req, res, next) ->
  req.body._id = database.getId()
  showcase = req.body.showcase == 'true'
  req.body.itemType = 'item'
  req.body.image = splitImgDesc req.body.image
  db.insertOne(req.body).then ->
     if showcase
       database.generateShowcase 'items', req.params.id, req.body
  res.redirect 'back'

router.post '/getData', (req, res, next) ->
  database.getDb().collection('item').findOne({'_id': database.getId req.body.id}).then (result) ->
    res.send result

router.post '/getChildren', (req, res, next) ->
  database.getDb().collection('item').find({'parentCollection': req.body.id}).toArray (err, result) ->
    if err then throw err else res.send result

router.post '/delete', (req, res, next) ->
  db.deleteOne({'_id': database.getId req.body.id}).then ->
    res.send true

router.post '/update/:id', (req, res, next) ->
  showcase = req.body.showcase == 'true'
  req.body.image = splitImgDesc req.body.image
  db.updateOne(
    {'_id': database.getId req.params.id},
    {$set: req.body}
  ).then ->
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
  else 
    err = new Error('Forbidden')
    err.status = 403
    next(err)
    
module.exports = router