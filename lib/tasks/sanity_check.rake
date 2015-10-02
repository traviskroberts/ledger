task sanity_check: :environment do
  puts "I’m working!" if Rails.env.production?
end
