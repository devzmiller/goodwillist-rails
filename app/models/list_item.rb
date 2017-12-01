class ListItem < ApplicationRecord

  def find_items_by_keyword
    InventoryItem.where("title like ?", '%' + self.keywords + '%')
  end
end
