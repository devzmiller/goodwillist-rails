class ListItem < ApplicationRecord

  def self.find_items_by_keyword(keyword)
    InventoryItem.where("title like ?", '%' + keyword + '%')
  end
end
