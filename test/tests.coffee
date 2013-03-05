
assert = require 'assert'
should = require 'should'

describe 'API Wrapper Test', ->

  it 'BuilderCharLimitation', ->

    ApiBuilder = require '../src/ApiBuilder'
    limit = 128
    testString = ''
    for i in [0..300]
      testString += 'a'
    aBuilder = new ApiBuilder
    aBuilder.builder 'name', testString
    length = (aBuilder.output()['name']).length
    limit.should.equal length

  it 'ApiDataPacketBuilderAccuracy', ->

    ApiDataPacketBuilder = require '../src/ApiDataPacketBuilder'
    adp = new ApiDataPacketBuilder
    [].should.eql (adp.buildDataPacket [])

    ApiEngagementRecord = require '../src/ApiEngagementRecord'

    aer_list = []

    aer = new ApiEngagementRecord '12-31-2012 12:59:59'
    aer.contextBuilder 'group', 'test1'
    aer.featureBuilder 'feat1', 'tfeat1'
    aer.identityBuilder 'ident1', 'tident1'

    aer_list.push aer

    aer = new ApiEngagementRecord '12-31-2013 12:59:59'
    aer.contextBuilder 'group', 'test2'
    aer.featureBuilder 'feat1', 'tfeat2'
    aer.identityBuilder 'ident1', 'tident2'

    ApiItemRecord = require '../src/ApiItemRecord'

    item = new ApiItemRecord 'item100'
    item.builder 'if1', 'if1_value'

    aer.itemsetBuilder item

    aer_list.push aer

    recs = adp.buildDataPacket aer_list

    (aer_list.length).should.equal recs.length
    'test1'.should.equal recs[0]['context']['group']
    'test2'.should.equal recs[1]['context']['group']

    'tfeat2'.should.equal recs[1]['features']['feat1']
    'tident1'.should.equal recs[0]['identity']['ident1']

    0.should.equal (recs[0]['itemset'].length)
    1.should.equal (recs[1]['itemset'].length)

    'if1_value'.should.equal recs[1]['itemset'][0]['features']['if1']
    'item100'.should.equal recs[1]['itemset'][0]['item_id']

  it 'ApiEngagementRecordAccuracy', ->

    ApiEngagementRecord = require '../src/ApiEngagementRecord'

    aer = new ApiEngagementRecord '12-31-2012 12:59:59'
    aer.contextBuilder 'group', 'test1'
    aer.featureBuilder 'feat1', 'tfeat1'
    aer.identityBuilder 'ident1', 'tident1'

    aer.setEngagement 'buy', 5.0

    (5.0).should.equal aer.getEngagementWeight()
    'buy'.should.equal aer.getEngagementType()

    'test1'.should.equal aer.getContext()['group']
    'tfeat1'.should.equal aer.getFeatures()['feat1']
    'tident1'.should.equal aer.getIdentity()['ident1']

    ApiItemRecord = require '../src/ApiItemRecord'

    item = new ApiItemRecord 'item100'
    item.builder 'if1', 'if1_value'

    aer.itemsetBuilder item

    item = new ApiItemRecord 'item200'
    item.builder 'if2', 'if2_value'

    aer.itemsetBuilder item

    2.should.equal (aer.getItemset().length)

    items = aer.getItemset()

    'item100'.should.equal items[0].getItemId()
    'item200'.should.equal items[1].getItemId()

  it 'ApiItemRecordAccuracy', ->

    ApiItemRecord = require '../src/ApiItemRecord'

    item = new ApiItemRecord 'item100'
    item.builder 'if1', 'if1_value'
    item.builder 'if2', 'if2_value'

    'item100'.should.equal item.getItemId()
    'if1_value'.should.equal item.output()['if1']
    'if2_value'.should.equal item.output()['if2']

  it 'JSONAccuracy', ->

    json_dict =
      result:
        code: 200
        message: 'test_message'

    ApiResponseReader = require '../src/ApiResponseReader'

    json_string = JSON.stringify json_dict

    rc = ApiResponseReader.getResultCode json_string
    200.should.equal rc

    rm = ApiResponseReader.getResultMessage json_string
    'test_message'.should.equal rm

    data =
      data: {}
    lst = []

    element1 =
      item_id: 'item100'
      n1: '1'
      n2: '2'
      n3: '3'

    element2 =
      item_id: 'item200'
      n1: '4'
      n2: '5'
      n3: '6'

    lst.push element1
    lst.push element2

    data['data']['list'] = lst

    json_data = JSON.stringify data

    recs = ApiResponseReader.getDataElements json_data
    '1'.should.equal recs[0]['n1']

  it 'FetchRecommendations', (done) ->
    
    ApiSession = require '../src/ApiSession'
    apiKey = 'aaaaa'
    url = 'https://api.perceptlink.com/api/1/test/ok_fetch_recommendations'
  
    aso = new ApiSession apiKey, url
    aso.getItemRecommendations (recs) ->
      3.should.equal recs.length
      200.should.equal recs[1]['item_id']
      'Z'.should.equal recs[2]['recommendations'][1]
      'A'.should.equal recs[0]['recommendations'][0]
      done()

  it 'FetchRecommendation', (done) ->

    ApiSession = require '../src/ApiSession'
    ApiSingletonRequest = require '../src/ApiSingletonRequest'

    apiKey = 'apiKey'
    url = 'https://api.perceptlink.com/api/1/test/ok_fetch_recommendation'

    singleton = new ApiSingletonRequest
    singleton.builder 'item_id', 150

    aso = new ApiSession apiKey, url
    aso.getItemRecommendation singleton, (data) ->
      150.should.equal data[0]['item_id']
      done()

  it 'FetchAllocations', (done) ->

    ApiSession = require '../src/ApiSession'
    apiKey = 'apiKey'
    url = 'https://api.perceptlink.com/api/1/test/ok_fetch_allocations'
  
    aso = new ApiSession apiKey, url
    aso.getContentAllocations (data) ->
      'sg'.should.equal data[0]['group']
      (0.46).should.equal data[2]['allocation']
      done()

  it 'FetchAllocation', (done) ->

    ApiSession = require '../src/ApiSession'
    ApiSingletonRequest = require '../src/ApiSingletonRequest'

    apiKey = 'apiKey'
    url = 'https://api.perceptlink.com/api/1/test/ok_fetch_allocation'

    singleton = new ApiSingletonRequest
    singleton.builder 'group', 'sg'

    aso = new ApiSession apiKey, url
    aso.getContentAllocation singleton, (data) ->
      'sg'.should.equal data[0]['group']
      done()

  it 'FetchLastRecordSubmitted', (done) ->

    ApiSession = require '../src/ApiSession'

    apiKey = 'apiKey'
    url = 'https://api.perceptlink.com/api/1/test/ok_last_record_submitted'

    aso = new ApiSession apiKey, url
    aso.fetchLastEngagementRecordSubmitted (data) ->
      context = data[0]['context']
      'sg'.should.equal context['group']
      1.should.equal data.length
      done()
    
