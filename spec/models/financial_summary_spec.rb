require 'rails_helper'

describe FinancialSummary do
  it 'summarizes over one day' do

    user = create(:user)

    Timecop.freeze(Time.now) do
      create(:transaction, user: user, category: :deposit, amount: Money.from_amount(2.12, :usd))
      create(:transaction, user: user, category: :deposit, amount: Money.from_amount(10, :usd))
    end

    Timecop.freeze(2.days.ago) do
      create(:transaction, user: user, category: :deposit)
    end

    subject = FinancialSummary.one_day(user: user, currency: :usd)
    expect(subject.count(:deposit)).to eq(2)
    expect(subject.amount(:deposit)).to eq(Money.from_amount(12.12, :usd))
  end

  it "mutliple format transaction amount  summed up to requested currency" do
    user = create(:user)

    Timecop.freeze(Time.now) do
      create(:transaction, user: user, category: :deposit, amount: Money.from_amount(2.12, :usd))
      create(:transaction, user: user, category: :deposit, amount: Money.from_amount(10, :cad))
    end
    subject = FinancialSummary.one_day(user: user, currency: :cad)
    expect(subject.count(:deposit)).to eq(2)
    expect(subject.amount(:deposit)).to eq(Money.from_amount(12.64, :cad))
  end
  
  it 'summarizes over one day for currency type :cad' do

    user = create(:user)

    Timecop.freeze(Time.now) do
      create(:transaction, user: user, category: :deposit, amount: Money.from_amount(2.12, :usd))
      create(:transaction, user: user, category: :deposit, amount: Money.from_amount(10, :usd))
    end

    Timecop.freeze(2.days.ago) do
      create(:transaction, user: user, category: :deposit)
    end

    subject = FinancialSummary.one_day(user: user, currency: :cad)
    expect(subject.count(:deposit)).to eq(2)
    expect(subject.amount(:deposit)).to eq(Money.from_amount(15.09, :cad))
  end

  it 'summarizes over seven days' do

    user = create(:user)

    Timecop.freeze(5.days.ago) do
      create(:transaction, user: user, category: :deposit, amount: Money.from_amount(2.12, :usd))
      create(:transaction, user: user, category: :deposit, amount: Money.from_amount(10, :usd))
    end

    Timecop.freeze(8.days.ago) do
      create(:transaction, user: user, category: :deposit)
    end

    subject = FinancialSummary.seven_days(user: user, currency: :usd)
    expect(subject.count(:deposit)).to eq(2)
    expect(subject.amount(:deposit)).to eq(Money.from_amount(12.12, :usd))
  end

  it 'summarizes over lifetime' do

    user = create(:user)

    Timecop.freeze(30.days.ago) do
      create(:transaction, user: user, category: :deposit, amount: Money.from_amount(2.12, :usd))
      create(:transaction, user: user, category: :deposit, amount: Money.from_amount(40, :usd))
      create(:transaction, user: user, category: :refund, amount: Money.from_amount(10, :usd))
      create(:transaction, user: user, category: :refund, amount: Money.from_amount(10, :usd))
      create(:transaction, user: user, category: :withdraw, amount: Money.from_amount(10, :usd))
      
    end

    Timecop.freeze(8.days.ago) do
      create(:transaction, user: user, category: :deposit)
    end

    subject = FinancialSummary.lifetime(user: user, currency: :usd)
    expect(subject.count(:deposit)).to eq(3)
    expect(subject.count(:withdraw)).to eq(1)
    expect(subject.count(:refund)).to eq(2)
    expect(subject.amount(:deposit)).to eq(Money.from_amount(43.12, :usd))
    expect(subject.amount(:refund)).to eq(Money.from_amount(20, :usd))
    expect(subject.amount(:withdraw)).to eq(Money.from_amount(10, :usd))
  end
end
