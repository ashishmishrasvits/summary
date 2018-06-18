class WalletsController < ApplicationController

  def create
    user = User.where(email: wallet_post_params[:email]).first
    if user
      wallet = Wallet.build_wallet(wallet_post_params,user)
      wallet.save!
      json_response({message: "Wallet successfully created", wallet_id: wallet.id})
    else
      json_response({message: "User not found"}, :not_found)
    end
  end

  def list
    user = User.where(email: wallet_get_params[:email]).first
    if user
      json_response(make_response(user)) 
    else
      json_response({message: "User not found"}, :not_found)
    end
  end
private

  def wallet_post_params
    params.require(:wallet).permit(:email, :currency, :balance)
  end

  def wallet_get_params
    params.permit(:email)
  end
  #Quick dirty way, could be done using ActiveModel::Serializer
  def make_response(user)
    res = {email: user.email, wallets:[]}
    user.wallets.each{|wallet| res[:wallets] << { id: wallet.id, balance: wallet.display_balance, currency: wallet.balance_currency}}
    res
  end
end
