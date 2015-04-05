require 'require_all'
require_all 'lib'

state = ARGV[0].upcase
raise 'Not a valid state'.red unless State::STATES.include? state

race = Race.new(state)
race.get_races
