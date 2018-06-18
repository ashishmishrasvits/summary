class FinancialSummaryController < ApplicationController

  def display
    user = User.where(email: financial_params[:email]).first
    if user
      FinancialSummary.validate_input_params(financial_params)
      fs = FinancialSummary.send(financial_params[:report_range].downcase, {user: user, currency: financial_params[:currency]})
      json_response(build_response(fs))
    else
      json_response({message: "User not found"}, :not_found)
    end
  end

  private
  def financial_params
    params.permit(:email, :category, :currency, :report_range)
  end

  def build_response(summary)
    category = financial_params[:category].downcase
    report_range = financial_params[:report_range].downcase

    count, amount = summary.count(category), summary.amount(category)
    {:category => category, 
     :report_range => report_range, 
     :count => count, 
     :currency => amount.currency.iso_code,
     :amount => amount.format(symbol: false)}
  end
end
