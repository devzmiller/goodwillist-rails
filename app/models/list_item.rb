class ListItem < ApplicationRecord

  #this is case sensitive. fix that
  def find_items_by_keyword
    InventoryItem.where("title like ?", '%' + self.keywords + '%')
  end
end
