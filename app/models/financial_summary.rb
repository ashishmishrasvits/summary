class FinancialSummary
    attr_accessor :transaction_type, :currency, :range, :user, :transactions 
    class << self
        [:one_day, :seven_days, :lifetime].each do |input_range|
            define_method(:"#{input_range}") do |input|
                self.new(input_range, input[:currency], input[:user])
            end
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