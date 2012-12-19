class RecurringTransaction < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  belongs_to :account

  attr_accessible :day, :description, :float_amount
  attr_accessor :float_amount

  validates :account, :presence => true
  validates :amount, :presence => true, :numericality => true
  validates :classification, :presence => true, :inclusion => { :in => %w(credit debit) }
  validates :day, :presence => true, :numericality => true
  validates :float_amount, :presence => true

  before_validation(:on => :create) do
    if float_amount.present?
      self.classification = float_amount.include?('-') ? 'debit' : 'credit'

      amt = float_amount.gsub(/[^\d\.]/, '').to_f
      self.amount = (amt * 100).round.to_i
    end
  end

  def dollar_amount
    amount.to_f / 100
  end

  def form_amount_value
    (classification == 'debit' ? '-' : '') + number_with_precision(dollar_amount, :precision => 2)
  end
end
