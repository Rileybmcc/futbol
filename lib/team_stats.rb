require_relative './game_stats'

module TeamStats
  include GameStats

  def team_info(team_id)
    headers = @teams.data[0].headers.map!(&:to_s)
    Hash[headers.zip((@teams.data.find { |team| team[:team_id] == team_id }).field(0..-1))].reject { |k| k == 'stadium' }
  end

  def best_season(team_id)
    seasonal_winrates(team_id).max_by { |_k, v| v }[0]
  end

  def worst_season(team_id)
    seasonal_winrates(team_id).min_by { |_k, v| v }[0]
  end

  def average_win_percentage(team_id)
    (seasonal_winrates(team_id).values.reduce(:+) / count_of_games_by_season(team_id).count).round(2)
  end

  def most_goals_scored(team_id)
    @game_teams.data.find_all { |game| game[:team_id] == team_id }.max_by { |game| game[:goals] }[:goals].to_i
  end

  def fewest_goals_scored(team_id)
    @game_teams.data.find_all { |game| game[:team_id] == team_id }.min_by { |game| game[:goals] }[:goals].to_i
  end

  def favorite_opponent(team_id)
    @teams.data.find { |team| team[:team_id] == win_hash(team_id).max_by { |_k, v| v }[0] }[:team_name]
  end

  def rival(team_id)
    @teams.data.find { |team| team[:team_id] == win_hash(team_id).min_by { |_k, v| v }[0] }[:team_name]
  end

  private

  def seasonal_winrates(team_id)
    season_wins = @games.data.reduce(Hash.new(0)) do |hash, game|
      (hash[game[:season]] += 1) if home_win?(team_id, game) || away_win?(team_id, game)
      hash
    end
    Hash[season_wins.map { |k, v| [k, v / (count_of_games_by_season(team_id)[k] * 2).to_f] }]
  end

  # #fav & #rival helper method
  def win_hash(team_id)
    games_against_counter = Hash.new(0)
    wins = @games.data.reduce(Hash.new(0)) do |hash, game|
      hash[game[:away_team_id]] += 1 if home_win?(team_id, game)
      hash[game[:home_team_id]] += 1 if away_win?(team_id, game)
      games_against_counter[game[:away_team_id]] += 1 if home?(team_id, game)
      games_against_counter[game[:home_team_id]] += 1 if away?(team_id, game)
      hash
    end
    Hash[wins.map { |k, v| [k, v / games_against_counter[k].to_f] }]
  end

  def home_win?(team_id, game)
    game[:home_team_id] == team_id && game[:home_goals] > game[:away_goals]
  end

  def away_win?(team_id, game)
    game[:away_team_id] == team_id && game[:home_goals] < game[:away_goals]
  end

  def home?(team_id, game)
    game[:home_team_id] == team_id
  end

  def away?(team_id, game)
    game[:away_team_id] == team_id
  end

end
