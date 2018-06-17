class Transaction < ApplicationRecord
  monetize :amount_cents

  validate :must_be_greater_than_zero
  validates :category, inclusion: %w[deposit refund withdraw]

  belongs_to :user

  after_save :make_immutable
  after_find :make_immutable

  scope :one_day, ->{ where("created_at > ?", 1.days.ago.to_time.localtime) }
  scope :seven_days, ->{ where("created_at > ?", 7.days.ago.to_time.localtime) }
  scope :lifetime, ->{ all }
  scope :category, ->(type) {where('category = ?', type)} 
  private

  def must_be_greater_than_zero
    errors.add(:amount, 'Must be greater than 0') if amount <= Money.from_amount(0, amount_currency)
  end

  def make_immutable
    self.readonly!
  end
end
