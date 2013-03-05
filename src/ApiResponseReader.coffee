
class ApiResponseReader

  @getResultCode: (json) ->
    res = @parseResultMessage json, 'result', 'code'
    if not res
      return 600
    parseInt res

  @getResultMessage: (json) ->
    @parseResultMessage json, 'result', 'message'

  @getDataElements: (json) ->
    data = @parseResultMessage json, 'data', 'list'
    if not data
      return []
    data

  @parseResultMessage: (json, top, name) ->
    vals = JSON.parse json
    if vals?[top]?
      if vals[top]?[name]?
        return vals[top][name]
    null

# ## Exports
module.exports = ApiResponseReader
