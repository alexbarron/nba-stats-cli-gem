class NbaStats::CLI
  
  def call
    start
  end

  def start
    puts "Welcome to the NBA Stats CLI Gem"
    puts "Here's the list of current teams"
    make_teams

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

    choose_team
    choose_player

    puts "Do you want to look up another player on this team? y/n"
    response = gets.strip
    while response == "y"
      choose_player
      puts "Do you want to look up another player on this team? y/n"
      response = gets.strip
    end

    puts "Do you want to look up another team? y/n"
    response = gets.strip
    if response == "y"
      start
    end
  end

  def make_teams
    teams_array = NbaStats::Scraper.get_teams
    NbaStats::Team.create_from_collection(teams_array)
  end

  def choose_team
    puts "Enter a team name to see their roster: "
    requested_team = gets.strip
    while !NbaStats::Team.team_names.include? requested_team
      puts "That team doesn't exist. Try again."
      requested_team = gets.strip
    end
    team = NbaStats::Team.all.detect {|team| team.name == requested_team}
    team.add_players
    puts team.name + " roster:"
    rows = [["Number", "Name", "Position", "Height", "Experience"]]
    team.players.each do |player|
      rows << [player.number, player.name, player.position, player.height, player.experience]
    end
    roster_table = Terminal::Table.new rows: rows
    puts roster_table
  end

  def choose_player
    puts "Enter a player name to see their individual stats: "
    requested_player = gets.strip
    while !NbaStats::Player.player_names.include? requested_player
      puts "That player isn't on this team. Try again."
      requested_player = gets.strip
    end
    player = NbaStats::Player.all.detect {|player| player.name == requested_player}
    stats_hash = NbaStats::Scraper.get_player_stats(player)
    player.add_player_stats(stats_hash)
    rows = [["Points/Game", "Assists/Game", "Rebounds/Game", "Blocks/Game", "Steals/Game", "FG%", "3P%", "FT%", "Minutes/Game",]]
    rows << [player.points_pg, player.assists_pg, player.rebounds_pg, player.blocks_pg, player.steals_pg, player.fg_percentage, player.three_percentage, player.ft_percentage, player.minutes_pg]
    puts "Here are #{player.name}'s 2015-16 stats: "
    stats_table = Terminal::Table.new rows: rows
    puts stats_table
  end

end