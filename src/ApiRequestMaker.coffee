
ApiHttpURLFetcher = require './ApiHttpURLFetcher'

class ApiRequestMaker

  constructor: (aso, apiUrl, apiKey, callback) ->
    @aso = aso
    @apiUrl = apiUrl
    @apiKey = apiKey
    @defaultUserAgent = 'PerceptLink NodeJS Wrapper 1.0'
    @defaultTimeout = 5000
    @contentType = 'application/json'
    @callback = callback

  fetchRecommendation: (req, callback) ->
    request = @buildSingletonRequest 'fetch_recommendation', req
    @doFetch request, callback

  fetchRecommendations: (callback) ->
    request = @buildRequest 'fetch_recommendations'
    @doFetch request, callback

  fetchAllocation: (req, callback) ->
    request = @buildSingletonRequest 'fetch_allocation', req
    @doFetch request, callback

  fetchAllocations: (callback) ->
    request = @buildRequest 'fetch_allocations'
    @doFetch request, callback
    
  fetchLastEngagementRecordSubmitted:(callback)  ->
    request = @buildRequest 'last_engagement_record_submitted'
    @doFetch request, callback

  postData: (data) ->
    request = @buildPostDataRequest 'post_event_data', data
    @doFetch request

  doFetch: (request, callback) ->
    @aso.setRawHTTPRequest request
    fetcher = new ApiHttpURLFetcher @defaultUserAgent, @defaultTimeout, 'POST'
    cb = (res) =>
      @aso.setRawHTTPResponse res
      callback res if callback?
    fetcher.postData @apiUrl, @contentType, request, cb

  buildRequest: (request_type) ->
    header = {}
    header['api_key'] = @apiKey
    header['type'] = request_type
    JSON.stringify header

  buildSingletonRequest: (request_type, criteria) ->
    header = {}
    header['api_key'] = @apiKey
    header['type'] = request_type
    header['criteria'] = criteria
    JSON.stringify header

  buildPostDataRequest: (request, data) ->
    header = {}
    header['api_key'] = @apiKey
    header['type'] = request_type
    header['data'] = data
    JSON.stringify header

# ## Exports
module.exports = ApiRequestMaker
