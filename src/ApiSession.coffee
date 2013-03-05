
ApiDataPacketBuilder = require './ApiDataPacketBuilder'
ApiRequestMaker      = require './ApiRequestMaker'
ApiResponseReader    = require './ApiResponseReader'

class ApiSession

  constructor: (apiKey, apiPostURL) ->

    @batchSize = 1000
    @apiKey = apiKey
    @apiPostURL = apiPostURL
    @mostRecentApiSessionRecord = null
    @asrList = []

    @rawHTTPRequest = null
    @rawHTTPResponse = null

    if not apiKey?
      throw new Error 'Did not supply an API key'
  
    if not apiPostURL?
      throw new Error 'Did not supply an API URL'

  addEngagementEvent: (t_asr) ->
    @asrList.push t_asr

  dispatchEngagementEvents: ->

    if @asrList.length < 1
      throw new Error 'No records to dispatch'

    pb = new ApiDataPacketBuilder
    dat = pb.buildDataPacket @asrList

    listSize = @asrList.length
    counter = 0

    while counter < listSize
      endMarker = counter + @batchSize
      if endMarker > listSize
        endMarker = listSize
      batch = dat.slice counter, endMarker
      areq = new ApiRequestMaker @, @apiPostURL, @apiKey
      result = areq.postData batch
      if (ApiResponseReader.getResultCode result) < 400
        counter = endMarker
        @mostRecentApiSessionRecord = batch[(batch.length -1)]
      else
        rm = ApiResponseReader.getResultMessage result
        throw new Error "Post failure with message: #{rm}; you can get most recent successfully sent record and try again"

  fetchLastEngagementRecordSubmitted: (callback) ->
    areq = new ApiRequestMaker @, @apiPostURL, @apiKey
    cb = (res) =>
      @setRawHTTPResponse res
      @verifyFetchState res
      callback @extractData()
    areq.fetchLastEngagementRecordSubmitted cb

  getItemRecommendation: (req, callback) ->
    areq = new ApiRequestMaker @, @apiPostURL, @apiKey
    cb = (res) =>
      @setRawHTTPResponse res
      callback @extractData()
    areq.fetchRecommendation req.output(), cb
    
  getItemRecommendations: (callback) ->
    areq = new ApiRequestMaker @, @apiPostURL, @apiKey
    cb = (res) =>
      ApiResponseReader.getDataElements res
      callback @extractData()
    areq.fetchRecommendations cb

  getContentAllocation: (req, callback) ->
    areq = new ApiRequestMaker @, @apiPostURL, @apiKey
    cb = (res) =>
      @setRawHTTPResponse res
      callback @extractData()
    areq.fetchAllocation req.output(), cb

  getContentAllocations: (callback) ->
    areq = new ApiRequestMaker @, @apiPostURL, @apiKey
    cb = (res) =>
      ApiResponseReader.getDataElements res
      callback @extractData()
    areq.fetchAllocations cb

  setRawHTTPRequest: (value) ->
    @rawHTTPRequest = value

  getRawHTTPRequest: ->
    @rawHTTPRequest

  setRawHTTPResponse: (value) ->
    @rawHTTPResponse = value

  getRawHTTPResponse: ->
    @rawHTTPResponse

  extractData: ->
    @verifyFetchState @rawHTTPResponse
    ApiResponseReader.getDataElements @rawHTTPResponse

  verifyFetchState: (res) ->
    if (ApiResponseReader.getResultCode res) > 200
      throw new Error 'Error on fetch: ' + (ApiResponseReader.getResultMessage res)

# ## Exports
module.exports = ApiSession
