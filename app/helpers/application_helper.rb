module ApplicationHelper

  def formatted_amount(amount, type)
    (type == 'debit' ? "-" : "") + number_to_currency(amount)
  end

end
