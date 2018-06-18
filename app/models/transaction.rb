class Transaction < ApplicationRecord
  monetize :amount_cents
  CATEGORIES = %w[deposit refund withdraw]
  validate :must_be_greater_than_zero
  validates :category, inclusion: CATEGORIES 

  belongs_to :user

  after_save :make_immutable
  after_find :make_immutable

  scope :one_day, ->{ where("created_at > ?", 1.days.ago.to_time.localtime) }
  scope :seven_days, ->{ where("created_at > ?", 7.days.ago.to_time.localtime) }
  scope :lifetime, ->{ all }
  scope :category, ->(type) {where('category = ?', type)} 

  # Refund can include extra logic of validating deposit made with same amount. For now this is not implemented
  def self.add_transaction(user,inputs)
    amount = Money.from_amount(inputs[:amount].to_f,inputs[:currency])
    trans = Transaction.new({user_id: user.id, 
                             category: inputs[:category].downcase, 
                             amount: amount})
    raise ActiveRecord::RecordInvalid.new(trans) unless trans.valid?
    #using lock in transaction to avoid data being updated 
    wallet = Wallet.find(inputs[:wallet_id])
    wallet.with_lock do
      wallet.send(inputs[:category],amount)
      wallet.save! && trans.save!
    end
    [trans,wallet.balance.format]
  end
  private

  def must_be_greater_than_zero
    errors.add(:amount, 'Must be greater than 0') if amount <= Money.from_amount(0, amount_currency)
  end

  def make_immutable
    self.readonly!
  end
end
