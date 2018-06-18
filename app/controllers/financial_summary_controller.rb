class FinancialSummaryController < ApplicationController

  rescue_from InputError do |e|
    json_response({message:e.error_message.join('\n')},:unprocessable_entity)
  end

  def display
    user = User.where(email: financial_params[:email]).first
    if user
      FinancialSummary.validate_input_params(financial_params)
      fs = FinancialSummary.send(financial_params[:report_range], {user: user, currency: financial_params[:currency]})
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
    count, amount = summary.count(financial_params[:category]), summary.amount(financial_params[:category])
    {:category => params[:category], 
     :report_range => financial_params[:report_range], 
     :count => count, 
     :currency => amount.currency.iso_code,
     :amount => amount.format(symbol: false)}
  end
end
