require 'colorize'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'require_all'
require_all 'lib'

class StateRace
  RESULT_LIMIT = 500

  def initialize(state)
    @state = state
    @state_races = []
  end

  def get_races!(page=1)
    puts "Getting races for #{@state.green}. Loading page #{page.to_s.cyan}..."
    url = "http://www.runningintheusa.com/Race/List.aspx?Rank=Upcoming&State=#{@state}&Page=#{page}"
    doc = Nokogiri::HTML(open(url))

    state_race_results = doc.css('tr.MenuGridViewRow, tr.MenuGridViewAlternatingRow').map do |row|
      formatted_row = row.css('td').each_with_index.map do |cell, idx|
        # For the 5th column, get the "listing info" link.
        if idx == 4
          next cell.css('a')
            .select { |entry| entry.content.strip == 'listing info' }
            .map { |link| link['href'] }
        end

        cell.content.strip.split(/\n/).map { |entry| entry.strip }
      end

      location       = formatted_row[3][0].split(', ')
      race_data      = formatted_row[2][1].gsub(/(, )|( \| )/, 'HACK').split('HACK')
      race_data_hash = race_data.reduce({}) { |hash, dist| hash[dist] = true; hash }

      next Race.new({
        'race_number' => formatted_row[0].first,
        'race_id'     => formatted_row[4].first.split(/raceid=/i).last,
        'race_date'   => Date.parse(formatted_row[1][1]),
        'race_name'   => formatted_row[2][0],
        'race_dist'   => race_data_hash,
        'race_city'   => location[0],
        'race_state'  => location[1],
        'race_county' => formatted_row[3][1]
      })
    end

    @state_races.concat(state_race_results)
    puts "`- Done getting races for #{@state.green} - page #{page.to_s.cyan}"

    state_race_status = doc.css('#ctl00_MainContent_List1_tdIndexRange').first.content.gsub(/^[0-9]+ to /, '').split(' of ')
    state_race_count  = state_race_status[0].to_i
    state_race_total  = state_race_status[1].to_i
    result_limit      = set_search_result_limit(state_race_total)

    if state_race_count < result_limit
      get_races!(page + 1)
    else
      print_race_data
      puts "DONE GETTING #{@state} RACES".green
    end
  end

  def print_race_data
    @state_races.each { |race| puts race.data }
  end

  def self.get_all_races!
    @all_state_races = []
    Constants::STATES.each do |state|
      state_race = StateRace.new(state)
      state_race.get_races!
      @all_state_races << state_race
    end
  end

private

  def set_search_result_limit(result_count)
    result_count < RESULT_LIMIT ? result_count : RESULT_LIMIT
  end
end
