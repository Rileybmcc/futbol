require 'csv'

require_relative './game_stats'
require_relative './league_stats'
require_relative './season_stats'
require_relative './team_stats'
require_relative './tracker_forge'

class StatTracker
  include GameStats
  include LeagueStats
  include SeasonStats
  include TeamStats
  # attr_reader :games, :teams, :game_teams

  def initialize(locations)
    @games = TrackerForge.for(Game, locations[:games])
    @teams = TrackerForge.for(Team, locations[:teams])
    @game_teams = TrackerForge.for(GameTeam, locations[:game_teams])
  end

  def self.from_csv(locations)
    StatTracker.new(locations)
  end
  
end
