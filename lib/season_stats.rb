module SeasonStats
  def winningest_coach(season)
    coach_checker(season)[1][0]
  end

  def worst_coach(season)
    coach_checker(season)[0][0]
  end

  def most_accurate_team(season)
    most = accuracy_checker(season)
    (@teams.data.find { |team| team[:team_id] == most[1][0] })[:team_name]
  end

  def least_accurate_team(season)
    least = accuracy_checker(season)
    (@teams.data.find { |team| team[:team_id] == least[0][0] })[:team_name]
  end

  def most_tackles(season)
    most = tackle_checker(season)
    (@teams.data.find { |team| team[:team_id] == most[1][0] })[:team_name]
  end

  def fewest_tackles(season)
    fewest = tackle_checker(season)
    (@teams.data.find { |team| team[:team_id] == fewest[0][0] })[:team_name]
  end

  private

  def list_game_ids_by_season(season)
    (@games.data.select { |game| game[:season] == season }).map { |matchup| matchup[:game_id] }
  end

  def coach_checker(season)
    if !@game_teams.win_percent[season]
      @game_teams.win_percent[season] = coach_wins(season)
    end
    @game_teams.win_percent[season].minmax_by {|_a, b| b }
  end

  def accuracy_checker(season)
    if !@teams.accuracy[season]
      @teams.accuracy[season] = team_accuracy(season)
    end
    @teams.accuracy[season].minmax_by {|_a, b| b }
  end

  def tackle_checker(season)
    if !@teams.tackles[season]
      @teams.tackles[season] = total_tackles(season)
    end
    @teams.tackles[season].minmax_by { |_a, b| b }
  end

  def coach_wins(season)
    games_played = Hash.new(0)
    placeholder = list_game_ids_by_season(season)
    games_won = @game_teams.data.reduce(Hash.new(0)) do |hash, game|
      if placeholder.include?(game[:game_id])
        games_played[game[:head_coach]] += 1
        hash[game[:head_coach]] += 1 if game[:result] == "WIN"
        hash[game[:head_coach]] += 0 if game[:result] != "WIN"
      end
      hash
    end
    Hash[games_played.map { |k, v| [k, games_won[k] / v.to_f] }]
  end

  def team_accuracy(season)
    team_goals = Hash.new(0)
    placeholder = list_game_ids_by_season(season)
    team_shots = @game_teams.data.reduce(Hash.new(0)) do |hash, game|
      if placeholder.include?(game[:game_id])
        hash[game[:team_id]] += game[:shots].to_i
        team_goals[game[:team_id]] += game[:goals].to_i
      end
      hash
    end
    Hash[team_shots.map { |k, v| [k, team_goals[k] / v.to_f] }]
  end

  def total_tackles(season)
    placeholder = list_game_ids_by_season(season)

    @game_teams.data.reduce(Hash.new(0)) do |hash, game|
      hash[game[:team_id]] += game[:tackles].to_i if placeholder.include?(game[:game_id])
      hash
    end
  end
end
