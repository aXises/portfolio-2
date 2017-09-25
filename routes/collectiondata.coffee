express = require 'express'
router = express.Router()
database = require '../routes/database'
item = require '../routes/item'
db = null

router.post '/new', (req, res, next) ->
  req.body._id = database.getId()
  db.insertOne(req.body).then () ->
    res.redirect 'back'

router.post '/getData', (req, res, next) ->
  db.findOne({'_id': database.getId req.body.id}).then (result) ->
    res.send result

router.post '/delete', (req, res, next) ->
  database.getDb().collection('item').updateMany(
    {
      'parentCollection': req.body.id
    },
    {
      $set: { 
        'parentCollection': null
        }
    }
  ).then () ->
      db.deleteOne({'_id': database.getId req.body.id}).then () ->
        res.send true

router.post '/update/:id', (req, res, next) ->
  db.updateOne(
    {'_id': database.getId req.params.id},
    {$set: req.body}
  ).then () ->
    res.redirect 'back'

router.get '/', (req, res, next) ->
  db = database.getDb().collection('collection')
  db.find({}).toArray (err, collections) ->
    database.getDb().collection('team').find({}).toArray (err, teams) ->
      res.render 'collectiondata',
        collectionKeys: Object.keys(collections)
        collections: collections,
        teamKeys: Object.keys(teams),
        teams: teams

module.exports = router