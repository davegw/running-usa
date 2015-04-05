task :default => :scraper

desc "Fetches runningintheusa.com data"
task :scraper, :state do |t, args|
  state = args[:state] || 'AK'
  ruby "bin/running_usa_scraper.rb #{state}"
end
