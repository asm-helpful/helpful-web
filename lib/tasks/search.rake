namespace :search do
  task :reindex => :environment do
    Message.find_each{|message| message.__elasticsearch__.index_document}
  end
end
