require 'rails_helper'

RSpec.describe WalletsController, type: :controller do
  context "create" do
    before(:each) do
      create(:user, email: "email@email.com")
    end

    it "returns wallet id when new wallet is created" do
      post :create, params: {wallet: { email: "email@email.com", balance: 100, currency: "usd"}}
      expect(JSON.parse(response.body)).to include("message" => "Wallet successfully created")
      expect(JSON.parse(response.body)).to include("wallet_id")
      expect(response.status).to eql 200
    end

    it "creates wallet if currency is not passed using USD as default" do
      post :create, params: {wallet: { email: "email@email.com", balance: 100 }}
      expect(JSON.parse(response.body)).to include("message"  => "Wallet successfully created")
      expect(JSON.parse(response.body)).to include("wallet_id")     
      expect(response.status).to eql 200
    end

    it "render error message when user doesnt exists" do
      post :create, params: {wallet: { email: "email@email1.com", balance: 100, currency: "usd"}}
      expect(JSON.parse(response.body)).to include("message"=>"User not found")
      expect(response.status).to eql 404
    end

    it "render error message when wrong currency type is passed" do
      post :create, params: {wallet: { email: "email@email.com", balance: 100, currency: "sd"}}
      expect(JSON.parse(response.body)).to include("message"=>"Unknown currency 'sd'")
      expect(response.status).to eql 422 
    end

    it "render input error if wallet has non numeric balance" do
      post :create, params: {wallet: { email: "email@email.com", balance: "abc", currency: "usd"}}
      expect(JSON.parse(response.body)).to include("message"=>"Invalid balance amount")
      expect(response.status).to eql 422 
    end
  end

  context "list" do 
    before(:each) do
      create(:user, email: "email@email.com")
    end
   
    it "render error message when user doesnt exists" do
      get :list, params:{ email:"email1@email.com"} 
      expect(JSON.parse(response.body)).to include("message"=>"User not found")
      expect(response.status).to eql 404
    end

    it "render blank wallets if no wallet present" do
      get :list, params:{ email:"email@email.com"} 
      expect(JSON.parse(response.body)).to include("email" => "email@email.com", "wallets" => [])
      expect(response.status).to eql 200
    end

    it "renders array of wallets for given user" do
      user = create(:user, email: "email1@email.com")
      wallet = create(:wallet, user: user)
      get :list, params:{ email:"email1@email.com"} 
      expect(JSON.parse(response.body)["wallets"].first).to include({"balance" => 0.0, "currency" => "USD"})
      expect(response.status).to eql 200
    end
  end 
end
