class ItemsController < ApplicationController

  def create
    @wallet = Wallet.find(params[:wallet_id])
    if not @wallet.write? session
      redirect_to @wallet, :alert => 'Permission denied'
    else
      @item = @wallet.items.create(item_params)
      redirect_to @wallet
    end
  end

  def destroy
    @wallet = Wallet.find(params[:wallet_id])
    if not @wallet.write? session
      redirect_toi :back, :alert => 'Permission denied'
    else
      @item = @wallet.items.find(params[:id])
      @item.destroy
      redirect_to :back 
    end
  end

private

  def item_params
    params.require(:item).permit :name, :detail, :delta, :time
  end

end
