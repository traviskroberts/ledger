describe 'recurring_transactions:process' do
  include_context 'rake'

  let(:account) { FactoryGirl.create(:account, :initial_balance => '100.00') }

  let(:prerequisites) { should include('environment') }

  it 'should create an entry on the specified day(1)' do
    trans = FactoryGirl.create(:recurring_transaction, :account => account, :day => 1, :float_amount => '5.95')
    FactoryGirl.create(:recurring_transaction, :account => account, :day => 2, :float_amount => '19.00')

    time = Time.local(Date.today.year, 6, 1, 2, 0, 0)
    Timecop.freeze(time)
    subject.invoke

    expect(Entry.count).to eq(2)
  end

  it 'should create an entry on the specified day(31)' do
    trans = FactoryGirl.create(:recurring_transaction, :account => account, :day => 31, :float_amount => '5.95')
    FactoryGirl.create(:recurring_transaction, :account => account, :day => 30, :float_amount => '19.00')

    time = Time.local(Date.today.year, 3, 31, 2, 0, 0)
    Timecop.freeze(time)
    subject.invoke

    expect(Entry.count).to eq(2)
  end

  it 'should run a transaction set for the 29th on the 28th of February' do
    trans = FactoryGirl.create(:recurring_transaction, :account => account, :day => 29, :float_amount => '5.95')
    FactoryGirl.create(:recurring_transaction, :account => account, :day => 27, :float_amount => '19.00')

    time = Time.local(Date.today.year, 2, 28, 2, 0, 0)
    Timecop.freeze(time)
    subject.invoke

    expect(Entry.count).to eq(2)
  end

  it 'should run a transaction set for the 30th on the 28th of February' do
    trans = FactoryGirl.create(:recurring_transaction, :account => account, :day => 30, :float_amount => '5.95')
    FactoryGirl.create(:recurring_transaction, :account => account, :day => 27, :float_amount => '19.00')

    time = Time.local(Date.today.year, 2, 28, 2, 0, 0)
    Timecop.freeze(time)
    subject.invoke

    expect(Entry.count).to eq(2)
  end

  it 'should run a transaction set for the 31st on the 28th of February' do
    trans = FactoryGirl.create(:recurring_transaction, :account => account, :day => 31, :float_amount => '5.95')
    FactoryGirl.create(:recurring_transaction, :account => account, :day => 27, :float_amount => '19.00')

    time = Time.local(Date.today.year, 2, 28, 2, 0, 0)
    Timecop.freeze(time)
    subject.invoke

    expect(Entry.count).to eq(2)
  end

  it 'should run a transaction set for the 31st on the 30th of April' do
    trans = FactoryGirl.create(:recurring_transaction, :account => account, :day => 31, :float_amount => '5.95')
    FactoryGirl.create(:recurring_transaction, :account => account, :day => 29, :float_amount => '19.00')

    time = Time.local(Date.today.year, 4, 30, 2, 0, 0)
    Timecop.freeze(time)
    subject.invoke

    expect(Entry.count).to eq(2)
  end

  it 'should run a transaction set for the 31st on the 30th of June' do
    trans = FactoryGirl.create(:recurring_transaction, :account => account, :day => 31, :float_amount => '5.95')
    FactoryGirl.create(:recurring_transaction, :account => account, :day => 29, :float_amount => '19.00')

    time = Time.local(Date.today.year, 6, 30, 2, 0, 0)
    Timecop.freeze(time)
    subject.invoke

    expect(Entry.count).to eq(2)
  end

  it 'should run a transaction set for the 31st on the 30th of September' do
    trans = FactoryGirl.create(:recurring_transaction, :account => account, :day => 31, :float_amount => '5.95')
    FactoryGirl.create(:recurring_transaction, :account => account, :day => 29, :float_amount => '19.00')

    time = Time.local(Date.today.year, 9, 30, 2, 0, 0)
    Timecop.freeze(time)
    subject.invoke

    expect(Entry.count).to eq(2)
  end

  it 'should run a transaction set for the 31st on the 30th of November' do
    trans = FactoryGirl.create(:recurring_transaction, :account => account, :day => 31, :float_amount => '5.95')
    FactoryGirl.create(:recurring_transaction, :account => account, :day => 29, :float_amount => '19.00')

    time = Time.local(Date.today.year, 11, 30, 2, 0, 0)
    Timecop.freeze(time)
    subject.invoke

    expect(Entry.count).to eq(2)
  end
end
