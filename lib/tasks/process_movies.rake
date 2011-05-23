namespace :movie do
  desc "Parse all files"
  task :download => :environment do
    Movie.schedule_downloads
  end
end
