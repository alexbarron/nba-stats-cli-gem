class NbaStats::CLI
  
  def call
    puts "Welcome to the NBA Stats CLI Gem"
    start
  end

  def start
    puts "Input one of the team names below to load their roster."
    puts "Input exit to leave this program."
    puts "Here's the list of current teams"

    make_teams if NbaStats::Team.all.empty?

    rows = [["Eastern Conference", "Western Conference"]]
    west_teams = NbaStats::Team.western_names
    east_teams = NbaStats::Team.eastern_names

    i = 0
    while i < 15
      rows << [east_teams[i], west_teams[i]]
      i += 1
    end

    team_table = Terminal::Table.new rows: rows
    puts team_table

    input = ""
    while input != "exit"
      puts "Input a team name to see their roster: "
      input = gets.strip
      if (NbaStats::Team.team_names.include? input)
        display_roster(input)
        puts "Input a player name to see their individual stats: "
        input = gets.strip
        while (NbaStats::Player.player_names.include? input)
          display_player_stats(input)
          puts "Input another player name from this team to see their stats."
          puts "Or input change teams to see another team's roster."
          input = gets.strip
          if input == "change teams" || input == "change team"
            start
          end
        end
        break
      end
    end
  end

  def make_teams
    teams_array = NbaStats::Scraper.get_teams
    NbaStats::Team.create_from_collection(teams_array)
  end

  def display_roster(requested_team)
    team = NbaStats::Team.all.detect {|team| team.name == requested_team}
    team.add_players if team.players.empty?
    puts team.name + " roster:"
    rows = [["Number", "Name", "Position", "Height", "Experience"]]
    team.players.each do |player|
      rows << [player.number, player.name, player.position, player.height, player.experience]
    end
    roster_table = Terminal::Table.new rows: rows
    puts roster_table
  end

  def display_player_stats(requested_player)
    player = NbaStats::Player.all.detect {|player| player.name == requested_player}
    player.add_player_stats
    rows = [["Points/Game", "Assists/Game", "Rebounds/Game", "Blocks/Game", "Steals/Game", "FG%", "3P%", "FT%", "Minutes/Game",]]
    rows << [player.points_pg, player.assists_pg, player.rebounds_pg, player.blocks_pg, player.steals_pg, player.fg_percentage, player.three_percentage, player.ft_percentage, player.minutes_pg]
    puts "Here are #{player.name}'s 2015-16 stats: "
    stats_table = Terminal::Table.new rows: rows
    puts stats_table
  end

end