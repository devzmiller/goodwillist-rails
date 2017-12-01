

desc "Generate the inventory database from eBay"
task "api_call" => :environment do
  ebay_response = InventoryItem.get_ebay_inventory
  InventoryItem.parse_all_json(ebay_response)
end
