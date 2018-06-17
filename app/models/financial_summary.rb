class FinancialSummary
    attr_accessor :transaction_by_type, :currency_type 
    class << self
        [:one_day, :seven_days, :lifetime].each do |name|
            define_method(:"#{name}") do |input|
                self.new(input[:user].transactions.send(name),input[:currency])
            end
        end
    end

    def initialize(transactions, currency)
        @transaction_by_type = {}
        transactions.each do |trans|
            @transaction_by_type[trans.category.to_sym] = [] unless @transaction_by_type[trans.category.to_sym]
            @transaction_by_type[trans.category.to_sym] << trans
        end
        @currency_type = currency 
    end

    def count(type)
        @transaction_by_type[type].count  
    end

    def amount(type)
        amount = @transaction_by_type[type].map(&:amount).inject(0, &:+)
        amount.exchange_to @currency_type 
    end
end