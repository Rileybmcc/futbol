require 'csv'
require 'erb'

require_relative './game_stats'
require_relative './league_stats'
require_relative './season_stats'
require_relative './team_stats'
require_relative './casts/tracker_forge'

class StatTracker
  include GameStats
  include LeagueStats
  include SeasonStats
  include TeamStats
  attr_reader :games, :teams, :game_teams, :erb_data

  def initialize(locations, data_arr)
    @games = TrackerForge.for(Game, locations[:games])
    @teams = TrackerForge.for(Team, locations[:teams])
    @game_teams = TrackerForge.for(GameTeam, locations[:game_teams])
    @erb_data = data_arr
  end

  def self.from_csv(locations, season_id = "18", team_id = "20132014")
    StatTracker.new(locations,[season_id, team_id])
  end

  def get_binding
    binding
  end
end
