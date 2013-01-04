class Account < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :entries, :dependent => :destroy, :order => 'created_at DESC'
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

  def dollar_balance
    ActionController::Base.helpers.number_to_currency(balance.to_f / 100)
  end

  def as_json(options={})
    opts = {
      :only => [:id, :url, :name],
      :methods => [:dollar_balance],
      :include => {
        :entries => {
          :only => [:id, :classification, :description],
          :methods => [:formatted_amount]
        }
      }
    }

    super(options.merge(opts))
  end

  private
    def populate_balance
      unless initial_balance.blank?
        amount = initial_balance.gsub(/[^\d\.]/, '')
        entries.create!(:float_amount => amount, :description => 'Initial balance')
      end
    end
end
