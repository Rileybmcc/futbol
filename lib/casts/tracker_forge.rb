require_relative './game'
require_relative './team'
require_relative './game_team'

class TrackerForge
  def self.for(mold, data)
    mold.new(data)
  end
end
