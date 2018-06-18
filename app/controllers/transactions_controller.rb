class TransactionsController < ApplicationController

  def create
    user = User.where(email: trans_params[:email]).first
    wallet = Wallet.where(id: trans_params[:wallet_id]).first
    if user && wallet
      tran,new_wallet_amount = Transaction.add_transaction(user,trans_params)
      json_response({transaction_id: tran.id, new_wallet_amount: new_wallet_amount, old_wallet_amount: wallet.balance.format})
    else
      json_response({message: "Either of user or wallet not found"}, :not_found)
    end
  end

  def trans_params
    params.require(:transaction).permit(:currency, :email, :wallet_id, :category, :amount)
  end
end
