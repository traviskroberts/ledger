class AccountSerializer < ActiveModel::Serializer
  attributes :id, :name, :url, :dollar_balance
end
