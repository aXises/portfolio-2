express = require 'express'
router = express.Router()
database = require '../routes/database'
item = require '../routes/item'
db = null

router.post '/new', (req, res, next) ->
  req.body._id = database.getId()
  db.collection('team').insertOne(req.body).then () ->
    res.redirect 'back'

router.post '/getData', (req, res, next) ->
  db.collection('team').findOne({'_id': database.getId req.body.id}).then (result) ->
    res.send result

router.post '/delete', (req, res, next) ->
  db.collection('team').deleteOne({'_id': database.getId req.body.id}).then () ->
    res.send true

router.post '/update/:id', (req, res, next) ->
  db.collection('team').updateOne(
    {'_id': database.getId req.params.id},
    {$set: req.body}
  ).then () ->
    res.redirect 'back'

router.get '/', (req, res, next) ->
  db = database.getDb()
  db.collection('team').find({}).toArray (err, teams) ->
    res.render 'teamdata',
      teamKeys: Object.keys(teams),
      teams: teams,

module.exports = router