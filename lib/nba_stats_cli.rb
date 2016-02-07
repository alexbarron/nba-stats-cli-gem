require_relative "../lib/scraper.rb"
require_relative "../lib/team.rb"
require_relative "../lib/player.rb"

class NbaStatsCli
  
  def self.start
    puts "Welcome to the NBA Stats CLI Gem"
    puts "Here's the list of current teams"
    make_teams
    Team.all.each do |team|
      puts team.name
    end
    puts "Enter a team name to see their roster: "
    requested_team = gets.strip
    team = Team.all.detect {|team| team.name == requested_team}
    team.add_players
    puts team.name + " roster:"
    rows = [["Number", "Name", "Position", "Height", "Experience"]]
    team.players.each do |player|
      rows << [player.number, player.name, player.position, player.height, player.experience]
    end
    roster_table = Terminal::Table.new rows: rows
    puts roster_table

    puts "Enter a player name to see their individual stats: "
    requested_player = gets.strip
    player = Player.all.detect {|player| player.name == requested_player}
    stats_hash = Scraper.get_player_stats(player)
    player.add_player_stats(stats_hash)
    rows = [["Points/Game", "Assists/Game", "Rebounds/Game", "Blocks/Game", "Steals/Game", "FG%", "3P%", "FT%", "Minutes/Game",]]
    rows << [player.points_pg, player.assists_pg, player.rebounds_pg, player.blocks_pg, player.steals_pg, player.fg_percentage, player.three_percentage, player.ft_percentage, player.minutes_pg]
    puts "Here are #{player.name}'s 2015-16 stats: "
    stats_table = Terminal::Table.new rows: rows
    puts stats_table
  end

  def self.make_teams
    teams_array = Scraper.get_teams
    Team.create_from_collection(teams_array)
  end

end