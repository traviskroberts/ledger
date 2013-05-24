class EntrySerializer < ActiveModel::Serializer
  attributes :id, :classification, :description, :formatted_amount, :formatted_date, :timestamp, :form_amount_value
end
