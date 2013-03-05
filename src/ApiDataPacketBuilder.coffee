

class ApiDataPacketBuilder

  buildDataPacket: (recs) ->

    dataMap = []

    for rec in recs

      newRec = {}
      chrono = {}
      engagement = {}

      chrono['occurred'] = rec.getDate()
      engagement['type'] = rec.getEngagementType()
      engagement['weight'] = rec.getEngagementWeight()

      newRec['chrono'] = chrono
      newRec['engagement'] = engagement
      newRec['identity'] = rec.getIdentity()
      newRec['context'] = rec.getContext()
      newRec['features'] = rec.getFeatures()
      newRec['itemset'] = []

      itemset = []

      for item in rec.getItemset()

        itemInfo = []
        itemInfo['item_id'] = item.getItemId()
        itemInfo['features'] = item.output()

        itemset.push itemInfo

      newRec['itemset'] = itemset

      dataMap.push newRec

    dataMap

# ## Exports
module.exports = ApiDataPacketBuilder
