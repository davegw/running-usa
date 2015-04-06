task :default => :scraper

desc 'Fetches runningintheusa.com data'
task :scraper, :state do |t, args|
  state = args[:state]
  ruby "bin/running_usa_scraper.rb #{state}"
end
