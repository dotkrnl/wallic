class WalletsController < ApplicationController

  def show
    @wallet = Wallet.find params[:id]
    if not @wallet.read? session
      redirect_to '/', :alert => 'Permission denied'
    else
      @tags = []
      @wallet.items.tag_counts.each do |tag|
        @tags << [@wallet.items.tagged_with(tag.name).sum('delta'), tag.name]
      end
      @tags.sort!.reverse!
    end
  end

  def new
  end

  def create
    wallet = wallet_params
    wallet['name'].strip!
    @wallet = Wallet.new wallet
    if not @wallet.save
      redirect_to '/', :alert => 'Bad information'
    else
      @wallet.auth! session, @wallet.secret_rw
      redirect_to share_wallet_path(@wallet.id), :notice => 'Wallet created'
    end
  end

  def auth
    @wallet = Wallet.find params[:id]
    @wallet.auth! session, params[:token]
    if @wallet.read? session
      redirect_to @wallet
    else
      redirect_to '/', :alert => 'Bad token'
    end
  end

  def share
    @wallet = Wallet.find params[:id]
    if not @wallet.read? session
      redirect_to '/', :alert => 'Permission denied'
    end
  end

private

  def wallet_params
    params.require(:wallet).permit :name, :detail
  end

end
