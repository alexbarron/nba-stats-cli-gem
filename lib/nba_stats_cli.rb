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
    table = Terminal::Table.new rows: rows
    puts table
  end

  def self.make_teams
    teams_array = Scraper.get_teams
    Team.create_from_collection(teams_array)
  end

end