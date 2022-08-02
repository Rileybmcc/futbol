module SeasonStats

  def list_game_ids_by_season(season_desired)
    (@games.select { |game| game[:season] == season_desired }).map { |matchup| matchup[:game_id] }
  end


  def winningest_coach(season_desired)
    coach_win_percentages_by_season(season_desired).max_by {|a, b| b }[0]
  end

  def worst_coach(season_desired)
    coach_win_percentages_by_season(season_desired).min_by {|a, b| b }[0]
  end


  def most_accurate_team(season_desired)
    wasd = team_accuracy(season_desired).max_by { |a, b| b }
    (@teams.find { |this_team| this_team[:team_id] == wasd[0]})[:team_name]
  end

  def least_accurate_team(season_desired)
    johnny = team_accuracy(season_desired).min_by { |a, b| b }
    (@teams.find { |this_team_1| this_team_1[:team_id] == johnny[0]})[:team_name]
  end


  def most_tackles(season_desired)
    bobby = total_tackles(season_desired).max_by { |a, b| b }
    (@teams.find { |this_team_2| this_team_2[:team_id] == bobby[0]})[:team_name]

  end

  def fewest_tackles(season_desired)
    bobby = total_tackles(season_desired).min_by { |_a, b| b }
    (@teams.find { |this_team_3| this_team_3[:team_id] == bobby[0]})[:team_name]
  end

  private

  def coach_win_percentages_by_season(season_desired)
    games_won = Hash.new(0)
    games_played = Hash.new(0)
    list_game_ids_by_season(season_desired).each do |num|
      @game_teams.select { |thing| thing[:game_id] == num }.each do |half|
        if half[:result] == "WIN"
          games_won[half[:head_coach]] += 1
          games_played[half[:head_coach]] += 1
        else
          games_won[half[:head_coach]] += 0
          games_played[half[:head_coach]] += 1
        end
      end
    end
    games_won.keys.each { |key| games_played[key] = (games_won[key].to_f / games_played[key].to_f) * 100 }
    games_played
  end

  def team_accuracy(season_desired)
    team_shots_1 = Hash.new(0)
    team_goals_1 = Hash.new(0)
    list_game_ids_by_season(season_desired).each do |num|
      @game_teams.select { |thing| thing[:game_id] == num }.each do |period|
        team_shots_1[period[:team_id]] += period[:shots].to_i
        team_goals_1[period[:team_id]] += period[:goals].to_i
      end
    end
    team_shots_1.map { |thornton| team_goals_1[thornton[0]] = team_goals_1[thornton[0]].to_f / team_shots_1[thornton[0]]}
    team_goals_1
  end

  def total_tackles(season_desired)
    team_tackles = Hash.new(0)
    list_game_ids_by_season(season_desired).each do |num|
      orr = @game_teams.select { |thing| thing[:game_id] == num }
      orr.each do |period|
        team_tackles[period[:team_id]] += period[:tackles].to_i
      end
    end
    team_tackles
  end

end
