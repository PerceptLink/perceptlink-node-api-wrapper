
class ApiBuilder

  constructor: ->
    @elements = {}
    @charLimit = 128

  builder: (name, value) ->
    @elements[name] = @__preprocessObject value

  output: ->
    @elements

  __preprocessObject: (obj) ->
    if (typeof obj) is 'string'
      obj = obj.substring 0, @charLimit
    obj

# ## Exports
module.exports = ApiBuilder
