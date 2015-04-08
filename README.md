# Running USA
Queries www.runningintheusa.com for race info.

To use:

1. Install ruby (included with OSX)
1. Install bundler globally (if not previously installed): `gem install bundler`
1. Clone the repo.
1. Install dependencies: `bundle install`
1. Query for races by state:  
`bundle exec ruby bin/running_usa_scraper.rb #{state_abbreviation}`

Sample queries:
```ruby
# Alaska:
bundle exec ruby bin/running_usa_scraper.rb AK

# California:
bundle exec ruby bin/running_usa_scraper.rb CA
```

Or query using a rake task:  
`rake scraper[AK]`

Currently aggregates and outputs state race info to the console.

TODO: Store data in database.
