namespace :search do
  task :reindex => :environment do
    Message.find_each{|message| message.update_search_index}
  end
end