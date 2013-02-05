class Account < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :entries, :dependent => :destroy, :order => 'date DESC'
  has_many :invitations
  has_many :recurring_transactions, :order => 'day'

  acts_as_url :name, :sync_url => true

  attr_accessible :name, :initial_balance
  attr_accessor :initial_balance

  validates :name, :presence => true
  validates :balance, :numericality => true

  after_create :populate_balance

  def to_param
    url
  end

  def as_json(options={})
    opts = {
      :only => [:id, :url, :name],
      :methods => [:dollar_balance]
    }

    super(options.merge(opts))
  end

  def dollar_balance
    ActionController::Base.helpers.number_to_currency(balance.to_f / 100)
  end

  private
    def populate_balance
      unless initial_balance.blank?
        amount = initial_balance.gsub(/[^\d\.]/, '')
        entries.create!(:float_amount => amount, :description => 'Initial balance', :date => Date.today)
      end
    end
end
