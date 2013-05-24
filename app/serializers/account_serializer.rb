class AccountSerializer < ActiveModel::Serializer
  embed :ids, :include => true
  attributes :id, :name, :url, :dollar_balance

  has_many :entries
end
