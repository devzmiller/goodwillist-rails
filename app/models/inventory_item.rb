class InventoryItem < ApplicationRecord

  # This URL gets all the results up to a specific end date. Since you can only get 10k results at a time, this will be necessary to get the entire inventory. Will also need to specify EndTimeFrom.
  # Need to handle pagination of response. 100 results per page. This request for everything ending up to three days ahead had 75 pages.
  # https://rossta.net/blog/paginated-resources-in-ruby.html for info on handling pagination.
  # Need to figure out how to increment the date filters in order to get entire inventory. Use Addressable gem to make the URL less of a mess (can modify a hash to change all the queries). "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsIneBayStores&SERVICE-VERSION=1.13.0&SECURITY-APPNAME=#{ENV['EBAY_ID']}&GLOBAL-ID=EBAY-US&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&itemFilter.name=EndTimeTo&itemFilter.value=2017-12-04T19:09:02.768Z&storeName=seattlegoodwillbooks&paginationInput.pageNumber=1"

  # 100 items per page, 100 pages per query. Must increment pages, and then increment endtime to get the next query, until all items retrieved.
  # Have to get rid of items that are no longer available. Can just drop the whole table, but then how to keep track of items that the user already knows are available. Figure that out later.

  # Method which initiates the retrieval of ebay inventory.
  # Method which initiates one query. Iterates over pages.

  def self.ebay_query
    uri = Addressable::URI.parse("http://svcs.ebay.com/services/search/FindingService/v1")
    query = {"OPERATION-NAME"=>"findItemsIneBayStores",
      "SERVICE-VERSION"=>"1.13.0",
      "SECURITY-APPNAME"=>"#{ENV['EBAY_ID']}",
      "GLOBAL-ID"=>"EBAY-US",
      "RESPONSE-DATA-FORMAT"=>"JSON",
      "REST-PAYLOAD"=>nil,
      "storeName"=>"seattlegoodwillbooks",
      "itemFilter.name"=>"EndTimeTo",
      "itemFilter.value"=>"2017-12-14T19:09:02.768Z",
      "paginationInput.pageNumber"=>"1"}
    uri.query_values = query
    response = RestClient.get(uri.to_str)
    json = JSON.parse(response.body, symbolize_names: true)
    page_count = json[:findItemsIneBayStoresResponse][0][:paginationOutput][0][:totalPages][0].to_i
    items = json[:findItemsIneBayStoresResponse][0][:searchResult][0][:item] #this is an array of hashes, one for each items
    (2..page_count).each do |page|
      query["paginationInput.pageNumber"] = page
      uri.query_values = query
      response = RestClient.get(uri.to_str)
      json = JSON.parse(response.body, symbolize_names: true)
      items.concat(json[:findItemsIneBayStoresResponse][0][:searchResult][0][:item])
    end
    items
  end

  def self.parse_json_item(json_item)
    p json_item
    if json_item[:galleryURL] == nil
      image_url = nil
    else
      image_url = json_item[:galleryURL][0]
    end
    if json_item[:condition] == nil
      condition = nil
    else
      condition = json_item[:condition][0][:conditionDisplayName][0]
    end
    InventoryItem.find_or_create_by(title: json_item[:title][0],
    url: json_item[:viewItemURL][0],
    image_url: image_url,
    condition: condition,
    ebay_id: json_item[:itemId][0])
  end

  def self.parse_all_json(items)
    items.each do |item|
      parse_json_item(item)
    end
  end

end
