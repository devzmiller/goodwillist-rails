class ListItemsController < ApplicationController

  def new
    @list_item = ListItem.new
  end

  def create
    @list_item = ListItem.find_or_create_by(keywords: params[:keywords])
    redirect_to list_items_path
  end

  def index
    @list_items = ListItems.all
  end
end
