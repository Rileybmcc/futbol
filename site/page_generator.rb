require 'erb'
require_relative '../lib/stat_tracker'

game_path = './data/games.csv'
team_path = './data/teams.csv'
game_teams_path = './data/game_teams.csv'

locations = {
  games: game_path,
  teams: team_path,
  game_teams: game_teams_path
}

write_location = './site/index.html'

stat_tracker = StatTracker.from_csv(locations)

template = %{
  <html>
    <head>
      <title>Your favorite Futbol stats!</title>
      <link href="minimal-table.css" rel="stylesheet" type="text/css">
    </head>
    <body>

      <h1>Futbol Stats From Data!</h1>

      <h2>Game Stats</h2>

      <table>
        <tr>
          <td>Method</td>
          <td>Stat</td>
        </tr>


      </table>

