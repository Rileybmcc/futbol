require 'csv'


class StatTracker
  attr_reader :games, :teams, :game_teams
  def initialize(games, teams, game_teams)
    @games = read_data(games)
    @teams = read_data(teams)
    @game_teams = read_data(game_teams)
    #require "pry"; binding.pry
  end

  def self.from_csv(locations)
    games = CSV.open(locations[:games], { headers: true, header_converters: :symbol })
    teams = CSV.open(locations[:teams], { headers: true, header_converters: :symbol })
    game_teams = CSV.open(locations[:game_teams], {headers: true, header_converters: :symbol })
    StatTracker.new(games, teams, game_teams)
  end

  def read_data(data)
    list_of_data = []
    data.each do |row|
      list_of_data << row
    end
    list_of_data
  end

  def highest_total_score
    max = @games.max_by { |game| game[:away_goals].to_i + game[:home_goals].to_i }
    max[:away_goals].to_i + max[:home_goals].to_i
  end

  def lowest_total_score
    min = @games.min_by { |game| game[:away_goals].to_i + game[:home_goals].to_i }
    min[:away_goals].to_i + min[:home_goals].to_i
  end

  def percentage_home_wins
    wins = @games.count { |game| game[:home_goals].to_i > game[:away_goals].to_i}
    games = @games.count
    (wins / games.to_f).round(2)
  end

  def percentage_visitor_wins
    wins = @games.count { |game| game[:home_goals].to_i < game[:away_goals].to_i}
    games = @games.count
    (wins / games.to_f).round(2)
  end

  def percentage_ties
    wins = @games.count { |game| game[:home_goals].to_i == game[:away_goals].to_i}
    games = @games.count
    (wins / games.to_f).round(2)
  end

  def count_of_games_by_season
    seasons = Hash.new
    @games.each do |game|
      if seasons[game[:season]]
        seasons[game[:season]] += 1
      else
        seasons[game[:season]] = 1
      end
    end
    seasons
  end

  def average_goals_per_game
    (@games.sum { |game| game[:away_goals].to_f + game[:home_goals].to_f } / @games.count).round(2)
  end

  def average_goals_by_season
    seasons = count_of_games_by_season
    avg_arr = []
    seasons.each do |season, count|
      games_in_season = @games.find_all { |game| game[:season] == season }
      avg_arr << ((games_in_season.sum { |game| game[:away_goals].to_i + game[:home_goals].to_i }) / count.to_f).round(2)
    end
    Hash[seasons.keys.zip(avg_arr)]
  end

  def best_offense
    teams = ((@games.map { |game| game[:home_team_id] }) + (@games.map { |game| game[:away_team_id] })).uniq.sort_by(&:to_i)
    avgs = []
    teams.each do |team|
      home_goal = (@games.find_all { |game| team == game[:home_team_id] }.map { |game| game[:home_goals].to_i }).sum
      away_goal = (@games.find_all { |game| team == game[:away_team_id] }.map { |game| game[:away_goals].to_i }).sum
      avgs << ((home_goal + away_goal).to_f / (@games.count { |game| (game[:home_team_id || :away_team_id]) == team })).round(3)
    end
    @teams.find { |team| team[:team_id] == (Hash[teams.zip(avgs)].max_by { |_k, v| v })[0] }[:team_name]
  end

  # Team Statistics Methods
  def team_info(team_id)
    headers = @teams[0].headers.map!(&:to_s)
    Hash[headers.zip((@teams.find { |team| team[:team_id] == team_id }).field(0..-1))].reject { |k| k == 'stadium' }
  end
end
