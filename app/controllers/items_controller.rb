class ItemsController < ApplicationController

  def create
    @wallet = Wallet.find(params[:wallet_id])
    if not @wallet.write? session
      redirect_to @wallet, :alert => 'Permission denied'
    end
    @item = @wallet.items.create(item_params)
    redirect_to @wallet
  end

  def destroy
    @wallet = Wallet.find(params[:wallet_id])
    if not @wallet.write? session
      redirect_to @wallet, :alert => 'Permission denied'
    end
    @item = @wallet.items.find(params[:id])
    @item.destroy
    redirect_to @wallet
  end

private

  def item_params
    params.require(:item).permit :name, :detail, :delta, :time
  end

end
