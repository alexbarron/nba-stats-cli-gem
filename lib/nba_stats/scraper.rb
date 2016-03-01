class NbaStats::Scraper

  def self.open_page(url)
    Nokogiri::HTML(open(url))
  end

  def self.get_teams
    page = open_page("http://www.basketball-reference.com/leagues/NBA_2016_standings.html")

    east_teams = page.css("table#E_standings td a")
    west_teams = page.css("table#W_standings td a")

    assign_teams(west_teams, "West") + assign_teams(east_teams, "East")
  end

  def self.assign_teams(teams, conference)
    assigned_teams = []
    teams.each do |team|
      name = team.text
      team_url = "http://www.basketball-reference.com" + team["href"]
      hash = {name: name, team_url: team_url, conference: conference}
      assigned_teams << hash unless assigned_teams.include? hash
    end
    assigned_teams
  end

  def self.get_roster(team)
    page = open_page(team.team_url)
    players_array = []
    players = page.css("table#roster tr")
    players.drop(1).each do |player|
      data_array = player.text.split("\n").map {|x| x.strip}
      number = data_array[1]
      name = data_array[2]
      position = data_array[3]
      height = data_array[4]
      data_array[8] == "R" ? experience = "Rookie" : experience = data_array[8] + " Years"
      player_url = "http://www.basketball-reference.com" + player.css("a").first["href"]

      hash = {name: name, number: number, position: position, height: height, experience: experience, player_url: player_url}
      players_array << hash
    end
    players_array
  end

  def self.get_player_stats(player)
    page = open_page(player.player_url)

    season = page.css("table#per_game tr.full_table").last
    stats_array = season.text.split("\n").map {|x| x.strip}
    stats_hash = {
      points_pg: stats_array[30], 
      assists_pg: stats_array[25], 
      rebounds_pg: stats_array[24], 
      blocks_pg: stats_array[27], 
      steals_pg: stats_array[26], 
      minutes_pg: stats_array[8], 
      fg_percentage: stats_array[11], 
      three_percentage: stats_array[14], 
      ft_percentage: stats_array[21]
    }

  end

end