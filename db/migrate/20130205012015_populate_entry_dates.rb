class PopulateEntryDates < ActiveRecord::Migration
  def up
    Entry.all.each do |entry|
      entry.date = entry.created_at
      entry.save!
    end
  end

  def down
    # nothing
  end
end
