express = require 'express'
router = express.Router()
database = require '../routes/database'
utilFunc = require '../routes/utilFunc'

router.get '/', (req, res, next) ->
  db = database.getDb()
  db.collection('collection').find({}).toArray (err, collection) ->
    if err then throw err;
    setA = utilFunc.sortDate(collection).splice 0, 6
    setB = setA.splice 0, 3
    res.render 'index', {
      title: 'AXISESIO',
      isHome: true,
      latestA: setA,
      latestB: setB
    }

module.exports = router