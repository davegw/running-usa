require 'colorize'
require 'require_all'
require_all 'lib'

search_all_states = false

if ARGV[0]
  state = ARGV[0].upcase
  raise 'Not a valid state'.red unless Constants::STATES.include? state

  race = Race.new(state)
  race.get_races!
else
  puts 'No state given'.yellow

  if search_all_states
    puts 'Getting races from all states'.light_cyan
    Race.get_all_races!
  end
end
