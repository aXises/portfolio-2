class baseItem
  constructor: (@_id, @name, @status, @type, @link, @description) ->

class item extends baseItem
  constructor: (@_id, @name, @status, @type, @link, @description, @date, @technologies, @images) ->
    super(@_id, @name, @status, @type, @link, @description)
    @itemType = 'item'
    @partOfTeam = null
    @collection = []

  setCollection: (collection) ->
    collection.addItem(@_id)
    if !@collection.includes(collection._id) then @collection.push(collection._id)

class collection extends baseItem
  constructor: (@_id, @name, @status, @type, @link, @description, @image, @hasItems, @showcase) ->
    super(@_id, @name, @status, @type, @link, @description)
    @itemType = 'collection'
    @partOfTeam = null
    if !@hasItems
      @hasItems = []
    
  addItem: (item) ->
    @hasItems.push(item)

  setTeam: (team) ->
    team.addCollection(@_id)

class team
  constructor: (@_id, @name, @logo, @link, @description, @showcase, @members) ->
    @itemType = 'team'
    @hasItems = []
    @hasCollections = []

  addItem: (item) ->
    @hasItems.push(item)

  addCollection: (collection) ->
    @hasCollections.push(collection)

module.exports = {
  item,
  collection,
  team
}