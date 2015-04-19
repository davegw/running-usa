require 'colorize'
require 'require_all'
require_all 'lib'

SEARCH_ALL_STATES = false

if ARGV[0]
  state = ARGV[0].upcase
  raise 'Not a valid state'.red unless Constants::STATES.include? state

  race = StateRace.new(state)
  race.get_races!
else
  puts 'No state given'.yellow

  if SEARCH_ALL_STATES
    puts 'Getting races from all states'.light_cyan
    StateRace.get_all_races!
  end
end
