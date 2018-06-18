class InputError < StandardError
  attr_accessor :error_message
  def initialize(message)
    self.error_message = message
  end
end