class InventoryItem < ApplicationRecord

  def self.get_ebay_inventory
    url = "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsIneBayStores&SERVICE-VERSION=1.13.0&SECURITY-APPNAME=#{ENV['EBAY_ID']}&GLOBAL-ID=EBAY-US&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&storeName=seattlegoodwillbooks&paginationInput.entriesPerPage=100"
    response = RestClient.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.parse_json_item(json_item)
    if json_item[:galleryURL] == nil
      image_url = nil
    else
      image_url = json_item[:galleryURL][0]
    end
    InventoryItem.find_or_create_by(title: json_item[:title][0],
    url: json_item[:viewItemURL][0],
    image_url: image_url,
    condition: json_item[:condition][0][:conditionDisplayName][0],
    ebay_id: json_item[:itemId][0])
  end

  def self.parse_all_json(json)
    json[:findItemsIneBayStoresResponse][0][:searchResult][0][:item].each do |item|
      parse_json_item(item)
    end
  end

end
