class ItemsController < ApplicationController

  def create
    @wallet = Wallet.find(params[:wallet_id])
    if not @wallet.write? session
      redirect_to @wallet, :alert => 'Permission denied'
    else
      @item = @wallet.items.new(item_params)
      if not @item.save
        redirect_to @wallet, :alert => 'Bad information'
      else
        redirect_to @wallet
      end
    end
  end

  def destroy
    @wallet = Wallet.find(params[:wallet_id])
    if not @wallet.write? session
      redirect_to :back, :alert => 'Permission denied'
    else
      @item = @wallet.items.find(params[:id])
      @item.destroy
      redirect_to :back 
    end
  end

  def index
    @wallet = Wallet.find(params[:wallet_id])
    if not @wallet.read? session
      redirect_to :back, :alert => 'Permission denied'
    else
      @title = @wallet.name
      @items = @wallet.items.paginate(:page => params[:page])
    end
  end

private

  def item_params
    params.require(:item).permit :name, :detail, :delta, :time
  end

end
