require 'require_all'
require_all 'lib/database.rb'

class Race
  attr_accessor :data

  def initialize(race_data)
    @data = race_data
    save
  end

  def save
    Database['races'].update(
      { 'state' => data['state'], 'race_id' => data['race_id'] },
      data,
      { :upsert  => true }
    )
  end
end
