require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do

  describe "#create" do
    before(:each) do
      @user  = create(:user)
      @wallet = create(:wallet, balance: Money.from_amount(200,"usd"))
    end

    ["deposit","withdraw","refund"].map do |category|
      it "creates transaction for given user and wallet for #{category}" do
     
        post :create, params: {email: @user.email, wallet_id: @wallet.id, currency:"usd", amount:"100", category:category}
        expect(response.status).to eq 200
        jresponse = JSON.parse(response.body) 
        trans = Transaction.first
        expect(jresponse).to include("transaction_id" => trans.id)
        if category == "withdraw"
          expect(jresponse).to include("new_wallet_amount"=>"$100.00", "old_wallet_amount"=>"$200.00")
        else
          expect(jresponse).to include("new_wallet_amount"=>"$300.00", "old_wallet_amount"=>"$200.00")
        end
        expect(trans.amount).to eql Money.from_amount(100,"usd")
        expect(trans.category).to eql category
      end
    end

    it "renders invalid transaction message if wallet amount goes lower then 0" do
      post :create, params: {email: @user.email, wallet_id: @wallet.id, currency:"usd", amount:"300", category: "withdraw"}
      expect(response.status).to eq 422
      expect(JSON.parse(response.body)).to include("message"=>"Validation failed: Balance Must be postive or zero")
    end
  end
end
