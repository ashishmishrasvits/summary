class Wallet < ApplicationRecord
  monetize :balance_cents

  validate :support_usd_cad

  belongs_to :user
  
  def self.build_wallet(params, user)
    wallet = self.new(balance: params[:balance], balance_currency: (params[:currency]||"usd").downcase, user: user)
    wallet
  end
  
  def display_balance
    (self.balance_cents/100).to_f
  end
  private

  def support_usd_cad
    if !%w[usd cad].include?(balance_currency.to_s.downcase)
      errors.add(:balance_currency, 'Only support for USD, CAD currencies')
    end
  end
end