desc 'Gather metrics for usage'
task metrics: :environment do
  Rails.logger = nil
  ActiveRecord::Base.logger = nil

  signups = User.where('created_at > ?', 30.days.ago).count
  messages = Message.where('created_at > ?', 30.days.ago).count
  accounts = Conversation.where('created_at > ?', 30.days.ago).group(:account_id).count.map { |a, c| [Account.find(a).name, c] }.sort_by(&:last).reverse
  top_accounts = accounts.take(10)

  puts "Last 30 days"
  puts "------------"
  puts "Signups: #{signups}"
  puts "Messages sent: #{messages}"
  puts "Active accounts: #{accounts.count}"
  puts "Top #10 accounts by conversation count:"
  top_accounts.each do |account, count|
    puts "  #{account}: #{count}"
  end

  puts

  signups = User.count
  messages = Message.count
  accounts = Conversation.group(:account_id).count.map { |a, c| [Account.find(a).name, c] }.sort_by(&:last).reverse
  top_accounts = accounts.take(10)

  puts "All time"
  puts "--------"
  puts "Signups: #{signups}"
  puts "Messages sent: #{messages}"
  puts "Active accounts: #{accounts.count { |a, c| c > 3 }}"
  puts "Top #10 accounts by conversation count:"
  top_accounts.each do |account, count|
    puts "  #{account}: #{count}"
  end
end
