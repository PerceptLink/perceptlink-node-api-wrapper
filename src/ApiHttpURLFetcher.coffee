
request = require 'request'

class ApiHttpURLFetcher

  responseCode: 600
  content: null

  constructor: (userAgent, timeout, method) ->
    @userAgent = userAgent
    @timeout = timeout
    @method = method

  getContent: ->
    @content

  getResponseCode: ->
    @responseCode

  getSuccessState: ->
    if @responseCode < 400
      return true
    false

  initialize: ->
    @content = null
    @responseCode = 600

  fetchContent: (url, contentType) ->
    @fetchURL url, contentType

  postData: (url, contentType, req, callback) ->
    @initialize()
    options =
      method: 'POST'
      url: url
      headers:
        'content-type': 'application/json'
      body: req
    request options, (error, response, body) =>
      if error
        throw new Error error
      @content = body
      callback body

  fetchURL: (url, contentType) ->

# ## Exports
module.exports = ApiHttpURLFetcher
