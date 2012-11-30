class Account < ActiveRecord::Base
  belongs_to :user
  has_many :entries, :dependent => :destroy, :order => 'created_at DESC'

  acts_as_url :name, :sync_url => true, :allow_duplicates => false, :scope => :user_id

  attr_accessible :name, :initial_balance
  attr_accessor :initial_balance

  validates :name, :presence => true, :uniqueness => {:sope => :user_id}
  validates :balance, :numericality => true

  after_create :populate_balance

  def to_param
    url
  end

  def dollar_balance
    balance.to_f / 100
  end

  private
    def populate_balance
      unless initial_balance.blank?
        amount = initial_balance.gsub(/[^\d\.]/, '')
        entries.create!(:float_amount => amount, :description => 'Initial balance')
      end
    end
end
