class ApplicationController < ActionController::API
  include Response

  rescue_from ActiveRecord::RecordInvalid do |e|
    json_response({ message: e.message }, :unprocessable_entity)
  end
  rescue_from  Money::Currency::UnknownCurrency do |e|
    json_response({ message: e.message }, :unprocessable_entity)
  end
end
