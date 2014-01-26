require 'SecureRandom'

class WalletsController < ApplicationController

  def show
    @wallet = Wallet.find params[:id]
    if not @wallet.read? session
      redirect_to '/', :alert => 'Permission denied'
    end
  end

  def new
  end

  def create
    wallet = wallet_params
    wallet['name'].strip!
    if wallet['name'] == ''
      wallet['name'] = 'Untitled'
    end
    wallet['secret_read'] = generate_secret
    wallet['secret_rw'] = generate_secret
    @wallet = Wallet.new wallet
    @wallet.save
    @wallet.auth! session, wallet['secret_rw']
    redirect_to @wallet, :notice => 'Wallet created'
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

private

  def generate_secret
    SecureRandom.hex Global.security.secret_len
  end

  def wallet_params
    params.require(:wallet).permit :name, :detail
  end

end
