class Entry < ActiveRecord::Base
  belongs_to :account

  attr_accessible :account_id, :description, :float_amount, :date
  attr_accessor :float_amount

  validates :account, :presence => true
  validates :amount, :presence => true, :numericality => true
  validates :classification, :presence => true, :inclusion => { :in => %w(credit debit) }
  validates :description, :presence => true
  validates :date, :presence => true

  before_validation do
    if float_amount.present?
      self.classification = float_amount.include?('-') ? 'debit' : 'credit'

      amt = float_amount.gsub(/[^\d\.]/, '').to_f
      self.amount = (amt * 100).round.to_i
    end
  end

  after_create :update_account_balance
  after_update :adjust_account_balance
  after_destroy :undo_entry

  def as_json(options={})
    opts = {
      :only => [:id, :classification, :description],
      :methods => [:formatted_amount, :formatted_date, :timestamp, :form_amount_value]
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

  def form_amount_value
    (classification == 'debit' ? '-' : '') + ActionController::Base.helpers.number_with_precision(dollar_amount, :precision => 2)
  end

  def formatted_date
    date.strftime("%m/%d/%Y")
  end

  def timestamp
    date.to_time.to_i
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

    def adjust_account_balance
      new_balance = nil

      if changes.include?(:amount) && changes.include?(:classification)
        if changes[:classification].first == 'credit'
          new_balance = (account.balance - changes[:amount].first) - self.amount
        else
          new_balance = (account.balance + changes[:amount].first) + self.amount
        end
      elsif changes.include?(:amount)
        if self.classification == 'credit'
          new_balance = (account.balance - changes[:amount].first) + self.amount
        else
          new_balance = (account.balance + changes[:amount].first) - self.amount
        end
      elsif changes.include?(:classification)
        # reverse the amount
        if self.classification == 'credit'
          new_balance = account.balance + (self.amount * 2)
        else
          new_balance = account.balance - (self.amount * 2)
        end
      end

      if new_balance.present?
        account.balance = new_balance
        account.save
      end
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
