class Entry < ActiveRecord::Base
  belongs_to :account

  attr_accessible :account_id, :description, :float_amount
  attr_accessor :float_amount

  validates :account, :presence => true
  validates :amount, :presence => true, :numericality => true
  validates :classification, :presence => true, :inclusion => { :in => %w(credit debit) }
  validates :description, :presence => true
  validates :float_amount, :presence => true

  before_validation(:on => :create) do
    if float_amount.present?
      self.classification = float_amount.include?('-') ? 'debit' : 'credit'

      amt = float_amount.gsub(/[^\d\.]/, '').to_f
      self.amount = (amt * 100).round.to_i
    end
  end

  after_save :update_account_balance
  after_destroy :undo_entry

  def as_json(options={})
    opts = {
      :only => [:id, :classification, :description],
      :methods => [:formatted_amount, :timestamp]
    }

    super(options.merge(opts))
  end

  def dollar_amount
    amount.to_f / 100
  end

  def credit?
    classification == 'credit'
  end

  def debit?
    classification == 'debit'
  end

  def formatted_amount
    (classification == 'debit' ? '-' : '') + ActionController::Base.helpers.number_to_currency(dollar_amount).to_s
  end

  def timestamp
    created_at.to_i
  end

  private
    def update_account_balance
      if credit?
        new_balance = account.balance + self.amount
      else
        new_balance = account.balance - self.amount
      end

      account.balance = new_balance
      account.save
    end

    def undo_entry
      if credit?
        new_balance = account.balance - self.amount
      else
        new_balance = account.balance + self.amount
      end

      account.balance = new_balance
      account.save
    end
end
