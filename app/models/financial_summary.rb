class FinancialSummary
  attr_accessor :transaction_type, :currency, :range, :user, :transactions 
  RANGES = ["one_day", "seven_days", "lifetime"]

  class << self
    RANGES.each do |input_range|
      define_method(:"#{input_range}") do |input|
        self.new(input_range, input[:currency], input[:user])
      end
    end

    def validate_input_params(params)
      errors = []
      errors << ("Invalid report_range, accepts only#{RANGES.join(',')}") unless RANGES.include?(params[:report_range].downcase) 
      errors << ("Invalid category, accepts only #{Transaction::CATEGORIES.join(',')}") unless Transaction::CATEGORIES.include?(params[:category].downcase) 
      raise InputError.new(errors) if errors.present?
      return true
    end
  end

  def initialize(range, currency, user)
    @range = range
    @currency_type = currency 
    @user = user
  end

  def count(type)
    get_transactions(type).count
  end

  def amount(type)
    amount = get_transactions(type).map(&:amount).inject(0, &:+)
    amount.exchange_to @currency_type 
  end

  def get_transactions(type)
    return @transactions if type == @transaction_type
    @transaction_type = type
    @transactions = @user.transactions.category(@transaction_type).send(range)
  end
end