class Wallet < ApplicationRecord
  monetize :balance_cents

  validate :support_usd_cad
  validate :must_be_greater_than_zero

  belongs_to :user
  
  def self.build_wallet(params, user)
    raise InputError.new("Invalid balance amount") if params[:balance] !~ /\A\d+(?:\.\d{0,2})?\z/
    amount = Money.from_amount(params[:balance].to_f, (params[:currency]||"usd").downcase)
    self.new(balance: amount, user: user)
  end
  
  def display_balance
    (self.balance_cents/100).to_f
  end
  
  def deposit(amount)
    self.balance += amount
  end
  alias refund deposit
  
  def withdraw(amount)
    self.balance -= amount
  end
  
  private

  def must_be_greater_than_zero
    errors.add(:balance, 'Must be postive or zero') if balance < Money.from_amount(0, balance_currency)
  end

  def support_usd_cad
    if !%w[usd cad].include?(balance_currency.to_s.downcase)
      errors.add(:balance_currency, 'Only support for USD, CAD currencies')
    end
  end
end