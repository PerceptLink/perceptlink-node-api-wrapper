
class ApiSingletonRequest

  data: {}

  builder: (name, value) ->
    @data[name] = value

  output: ->
    @data

# ## Exports
module.exports = ApiSingletonRequest
