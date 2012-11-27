class Account < ActiveRecord::Base
  belongs_to :user
  has_many :entries, :dependent => :destroy, :order => :created_at

  attr_accessible :balance, :name, :initial_balance
  attr_accessor :initial_balance

  validates :name, :presence => true, :uniqueness => {:sope => :user_id}
  validates :balance, :numericality => true

  before_create :convert_balance

  def dollar_balance
    balance.to_f / 100
  end

  private
    def convert_balance
      initial_balance.gsub!(/[^\d\.]/, '')
      self.balance = (initial_balance.to_f * 100).to_i unless balance.blank?
    end
end
