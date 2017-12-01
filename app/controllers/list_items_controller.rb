class ListItemsController < ApplicationController

  def new
    @list_item = ListItem.new
  end

  def create

    @list_item = ListItem.find_or_create_by(list_item_param)
    redirect_to list_items_path
  end

  def index
    @list_items = ListItem.all
  end

  private

  def list_item_param
    params.require(:list_item).permit(:keywords)
  end
end
