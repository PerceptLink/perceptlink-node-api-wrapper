
ApiBuilder = require './ApiBuilder'

class ApiItemRecord

  constructor: (itemId) ->
    @itemId = itemId
    @itemFeatures = new ApiBuilder

  builder: (name, value) ->
    @itemFeatures.builder name, value

  getItemId: ->
    @itemId

  output: ->
    @itemFeatures.output()

# ## Exports
module.exports = ApiItemRecord
