
ApiBuilder = require './ApiBuilder'

class ApiEngagementRecord

  constructor: (date) ->

    @transactionDate = date

    @context = new ApiBuilder
    @identity = new ApiBuilder
    @features = new ApiBuilder

    @itemset = []

    @engagementType = null
    @engagementWeight = null

    @charLimit = 128

  identityBuilder: (name, value) ->
    @identity.builder name, value

  contextBuilder: (name, value) ->
    @context.builder name, value

  featureBuilder: (name, value) ->
    @features.builder name, value

  itemsetBuilder: (item) ->
    @itemset.push item

  setEngagement: (engagementType, engagementWeight) ->
    engagementWeight = parseInt engagementWeight
    if engagementWeight < 0
      engagementWeight = 0.0
    if engagementType.length > @charLimit
      engagementType = engagementType.substr 0, @charLimit + 1
    @engagementType = engagementType
    @engagementWeight = engagementWeight

  getContext: ->
    @context.output()

  getIdentity: ->
    @identity.output()

  getFeatures: ->
    @features.output()

  getItemset: ->
    @itemset

  getDate: ->
    @transactionDate

  getEngagementType: ->
    @engagementType

  getEngagementWeight: ->
    @engagementWeight

# ## Exports
module.exports = ApiEngagementRecord
