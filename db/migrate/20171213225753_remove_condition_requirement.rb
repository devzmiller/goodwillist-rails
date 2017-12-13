class RemoveConditionRequirement < ActiveRecord::Migration[5.1]
  def change
    change_column_null :inventory_items, :condition, true
  end
end
