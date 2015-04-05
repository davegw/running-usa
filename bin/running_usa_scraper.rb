require 'mechanize'
require 'nokogiri'
require 'open-uri'

url = 'http://www.runningintheusa.com/Race/List.aspx?State=AL'
doc = Nokogiri::HTML(open(url))

state_races = doc.css('tr.MenuGridViewRow, tr.MenuGridViewAlternatingRow').map do |row|
  formatted_row = row.css('td').map do |cell|
      cell.content.strip.split(/\n/).map { |entry| entry.strip }
  end

  location       = formatted_row[3][0].split(', ')
  race_data      = formatted_row[2][1].gsub(/(, )|( \| )/, 'HACK').split('HACK')
  race_data_hash = race_data.reduce({}) { |hash, dist| hash[dist] = true; hash }

  next {
    'race_number' => formatted_row[0],
    'race_date'   => Date.parse(formatted_row[1][1]),
    'race_name'   => formatted_row[2][0],
    'race_dist'   => race_data_hash,
    'race_city'   => location[0],
    'race_state'  => location[1],
    'race_county' => formatted_row[3][1]
  }
end
