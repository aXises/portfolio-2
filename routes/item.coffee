class baseItem
  constructor: (@_id, @name, @status, @type, @link, @description) ->

class item extends baseItem
  constructor: (@_id, @name, @status, @type, @link, @description, @date, @technologies, @images) ->
    super(@_id, @name, @status, @type, @link, @description)
    @itemType = 'item'
    @collection = []

  setCollection: (collection) ->
    collection.addItem(@_id)
    if !@collection.includes(collection._id) then @collection.push(collection._id)

  setTeam: (team) ->
    @team = team._id
    team.addItem(@_id)

class collection extends baseItem
  constructor: (@_id, @name, @status, @type, @link, @description, @image, @hasItems, @showcase) ->
    super(@_id, @name, @status, @type, @link, @description)
    @itemType = 'collection'
    if !@hasItems
      @hasItems = []
    
  addItem: (item) ->
    @hasItems.push(item)

  setTeam: (team) ->
    team.addCollection(@_id)

class team
  constructor: (@_id, @name, @logo, @members, @site, @description) ->
    @itemType = 'team'
    @hasItems = []
    @hasCollections = []

  addMember: (members) ->
    console.log(members, typeof(members))
    if typeof(members) == 'object'
      for member in members
        @members.push(member)
    else
      @members.push(members)

  addItem: (items) ->
    @hasItems.push(items)

  addCollection: (collection) ->
    @hasCollections.push(collection)

module.exports = {
  item,
  collection,
  team
}