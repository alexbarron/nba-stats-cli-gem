class NbaStats::CLI
  
  def call
    puts "Welcome to the NBA Stats CLI Gem"
    start
  end

  def start
    puts "Input one of the team names below to load their roster."
    puts "Input exit to leave this program."
    puts "Here's the list of current teams"

    display_teams

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

  def display_teams
    NbaStats::Scraper.new.teams
    puts Terminal::Table.new rows: NbaStats::Team.team_rows
  end

  def display_roster(requested_team)
    team = NbaStats::Team.all.detect {|team| team.name == requested_team}

    team.add_players if team.players.empty?

    puts team.name + " roster:"

    puts Terminal::Table.new rows: team.roster_rows
  end

  def display_player_stats(requested_player)
    player = NbaStats::Player.all.detect {|player| player.name == requested_player}

    player.add_player_stats

    puts "Here are #{player.name}'s 2015-16 stats: "
    puts Terminal::Table.new rows: player.stat_rows
  end

end