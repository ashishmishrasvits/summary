require 'rails_helper'

RSpec.describe FinancialSummaryController, type: :controller do
  context "display" do
    before(:each) do 
      @user = create(:user)
      Timecop.freeze(1.days.ago) do
        create(:transaction, user: @user, category: :deposit, amount: Money.from_amount(2.12, :usd))
        create(:transaction, user: @user, category: :deposit, amount: Money.from_amount(40, :usd))
        create(:transaction, user: @user, category: :refund, amount: Money.from_amount(10, :usd))
      end
    end

    it "displays financial summary for one_day and category deposit" do
      post :display, params: {email: @user.email, category: "deposit", report_range: "lifetime", currency: "usd"}
      expect(JSON.parse(response.body)).to include("category"=>"deposit","report_range"=>"lifetime","count"=>2,"currency" =>"USD","amount" =>"42.12")
      expect(response.status).to eq 200
    end

    it "displays financial summary for one_day with requested currency type" do
      post :display, params: {email: @user.email, category: "deposit", report_range: "lifetime", currency: "cad"}
      expect(JSON.parse(response.body)).to include("category"=>"deposit","report_range"=>"lifetime","count"=>2,"currency" =>"CAD","amount" =>"52.45")
      expect(response.status).to eq 200
    end

    it "responds with message if currency is unsupported" do 
      post :display, params: {email: @user.email, category: "deposit", report_range: "lifetime", currency: "CA"}
      expect(JSON.parse(response.body)).to include("message" => "Unknown currency 'ca'")
      expect(response.status).to eq 422
    end

    it "reponds with user not found if user doesnt exists" do
      post :display, params: {email: "someemai@email.com", category: "deposit", report_range: "lifetime", currency: "CA"}
      expect(JSON.parse(response.body)).to include("message" =>"User not found")    
      expect(response.status).to eq 404
    end

    it "responds with invalid report range for unknown range" do
      post :display, params: {email: @user.email, category: "deposit", report_range: "two_days", currency: "usd"}
      expect(JSON.parse(response.body)).to include("message" => "Invalid report_range, accepts onlyone_day,seven_days,lifetime")    
      expect(response.status).to eq 422
    end

    it "responds with invalid category for unknown category" do
      post :display, params: {email: @user.email, category: "deposit1", report_range: "one_day", currency: "usd"}
      expect(JSON.parse(response.body)).to include("message" => "Invalid category, accepts only deposit,refund,withdraw")    
      expect(response.status).to eq 422
    end
  end
end
