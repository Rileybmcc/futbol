require 'erb'
require_relative './lib/stat_tracker'

game_path = './data/games.csv'
team_path = './data/teams.csv'
game_teams_path = './data/game_teams.csv'

locations = {
  games: game_path,
  teams: team_path,
  game_teams: game_teams_path
}

erb_file = './site/stats.html.erb' 
html_file = './site/index.html'

erb_str = File.read(erb_file)

puts "Please enter team id (ex: 18):"
team_id = gets.chomp.to_s
puts "Please enter Season (ex: 20132014):"
season = gets.chomp.to_s

stat_tracker = StatTracker.from_csv(locations, team_id, season)

renderer = ERB.new(erb_str)
result = renderer.result(stat_tracker.get_binding)

File.open(html_file, 'w') do |f|
  f.write(result)
end
