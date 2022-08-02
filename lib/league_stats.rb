module LeagueStats

  def count_of_teams
    @teams.count
  end

  def team_ids
     ((@games.map { |game| game[:home_team_id] }) + (@games.map { |game| game[:away_team_id] })).uniq.sort_by(&:to_i)
  end

  def best_offense
    avgs = []
    team_ids.each do |team|
      home_goal = (@games.find_all { |game| team == game[:home_team_id] }.map { |game| game[:home_goals].to_i }).sum
      away_goal = (@games.find_all { |game| team == game[:away_team_id] }.map { |game| game[:away_goals].to_i }).sum
      avgs << ((home_goal + away_goal).to_f / (@games.count { |game| (game[:home_team_id || :away_team_id]) == team })).round(3)
    end
    @teams.find { |team| team[:team_id] == (Hash[team_ids.zip(avgs)].max_by { |_k, v| v })[0] }[:team_name]
  end

  def worst_offense
    avgs = []
    team_ids.each do |team|
      home_goal = (@games.find_all { |game| team == game[:home_team_id]}.map { |game| game[:home_goals].to_i}).sum
      away_goal = (@games.find_all { |game| team == game[:away_team_id]}.map { |game| game[:away_goals].to_i}).sum
      avgs << ((home_goal + away_goal).to_f / (@games.find_all { |game| game[:home_team_id] == team || game[:away_team_id] == team}).count).round(3)
    end
    @teams.find { |team| team[:team_id] == (Hash[team_ids.zip(avgs)].min_by { |_k, v| v })[0] }[:team_name]
  end

  def highest_scoring_visitor
    avgs = []
    team_ids.each do |team|
      away_goal = (@games.find_all { |game| team == game[:away_team_id]}.map { |game| game[:away_goals].to_i}).sum
      avgs << ((away_goal).to_f / (@games.find_all { |game| game[:away_team_id] == team}).count).round(3)
    end
    highest_visitor = (Hash[team_ids.zip(avgs)].max_by { |_k, v| v })[0]
    @teams.find { |team| team[:team_id] == highest_visitor }[:team_name]
  end

  def highest_scoring_home_team
    avgs = []
     team_ids.each do |team|
      home_goal = (@games.find_all { |game| team == game[:home_team_id]}.map { |game| game[:home_goals].to_i}).sum
      avgs << ((home_goal).to_f / (@games.find_all { |game| game[:home_team_id] == team}).count).round(3)
    end
    highest_home_team = (Hash[team_ids.zip(avgs)].max_by { |_k, v| v })[0]
    @teams.find { |team| team[:team_id] == highest_home_team }[:team_name]
  end

  def lowest_scoring_visitor
    avgs = []
    team_ids.each do |team|
      away_goal = (@games.find_all { |game| team == game[:away_team_id]}.map { |game| game[:away_goals].to_i}).sum
      avgs << ((away_goal).to_f / (@games.find_all { |game| game[:away_team_id] == team}).count).round(3)
    end
    lowest_visitor = (Hash[team_ids.zip(avgs)].min_by { |_k, v| v })[0]
    @teams.find { |team| team[:team_id] == lowest_visitor }[:team_name]
  end

  def lowest_scoring_home_team
    avgs = []
    team_ids.each do |team|
      home_goal = (@games.find_all { |game| team == game[:home_team_id]}.map { |game| game[:home_goals].to_i}).sum
      avgs << ((home_goal).to_f / (@games.find_all { |game| game[:home_team_id] == team}).count).round(3)
    end
    lowest_home_team = (Hash[team_ids.zip(avgs)].min_by { |_k, v| v })[0]
    @teams.find { |team| team[:team_id] == lowest_home_team }[:team_name]
  end
end
