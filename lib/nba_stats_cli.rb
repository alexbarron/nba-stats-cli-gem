require_relative "../lib/scraper.rb"
require_relative "../lib/team.rb"

class NbaStatsCli
  
  def self.start
    puts "Welcome to the NBA Stats CLI Gem"
    puts "Here's the list of current teams"
    make_teams
    Team.all.each do |team|
      puts team.name + ": #{team.team_url}"
    end
  end

  def self.make_teams
    teams_array = Scraper.get_teams
    Team.create_from_collection(teams_array)
  end
end