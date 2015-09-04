every :day, at: "1:00am" do
  rake "recurring_transactions:process"
end
