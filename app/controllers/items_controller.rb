class ItemsController < ApplicationController

  def create
    @wallet = Wallet.find params[:wallet_id]
    if not @wallet.write? session
      redirect_to @wallet, :alert => 'Permission denied'
    else
      @item = @wallet.items.new item_params
      extract_tags_from_name
      if not @item.save
        redirect_to @wallet, :alert => 'Bad information'
      else
        redirect_to @wallet
      end
    end
  end

  def destroy
    @wallet = Wallet.find params[:wallet_id]
    if not @wallet.write? session
      redirect_to :back, :alert => 'Permission denied'
    else
      @item = @wallet.items.find params[:id]
      @item.destroy
      redirect_to :back 
    end
  end

  def index
    @wallet = Wallet.find params[:wallet_id]
    if not @wallet.read? session
      redirect_to :back, :alert => 'Permission denied'
    else
      @items = @wallet.items.order('time').paginate :page => params[:page]
    end
  end

  def edit
    @wallet = Wallet.find params[:wallet_id]
    if not @wallet.write? session
      redirect_to :back, :alert => 'Permission denied'
    else
      @item = @wallet.items.find params[:id]
    end
  end

  def update
    @wallet = Wallet.find params[:wallet_id]
    if not @wallet.write? session
      redirect_to :back, :alert => 'Permission denied'
    else
      @item = @wallet.items.find params[:id]
      begin
        @item.update_attributes(item_params)
        redirect_to @wallet, :alert => 'Item updated'
      rescue
        redirect_to edit_wallet_item_path, :alert => 'Bad information'
      end
    end
  end

  def tag
    @wallet = Wallet.find params[:wallet_id]
    if not @wallet.write? session
      redirect_to :back, :alert => 'Permission denied'
    else
      @item = @wallet.items.find params[:id]
      aTag = params[:tag].gsub '#', ''
      @item.tag_list.add aTag
      @item.save
      redirect_to :back
    end
  end

  def untag
    @wallet = Wallet.find params[:wallet_id]
    if not @wallet.write? session
      redirect_to :back, :alert => 'Permission denied'
    else
      @item = @wallet.items.find params[:id]
      @item.tag_list.remove params[:tag]
      @item.save
      redirect_to :back
    end
  end

private

  def item_params
    params.require(:item).permit :name, :detail, :delta, :time
  end

  def extract_tags_from_name
    info = @item.name.split '#'
    info[0] = info[0] || ''
    @item.name = info[0].strip
    info[1..-1].each do |tag|
      if tag.strip != ''
        @item.tag_list.add tag.strip
      end
    end
  end

end
