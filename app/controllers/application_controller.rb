class ApplicationController < ActionController::API
  include Response

  rescue_from ActiveRecord::RecordInvalid do |e|
    json_response({ message: e.message }, :unprocessable_entity)
  end

  rescue_from  Money::Currency::UnknownCurrency do |e|
    json_response({ message: e.message }, :unprocessable_entity)
  end

  rescue_from InputError do |e|
    message = e.error_message.is_a?(Array) ? e.error_message.join('\n') : e.error_message
    json_response({message: message},:unprocessable_entity)
  end

  rescue_from ArgumentError, ActionController::ParameterMissing do |e|
    json_response({ message: e.message }, :unprocessable_entity)
  end
end
