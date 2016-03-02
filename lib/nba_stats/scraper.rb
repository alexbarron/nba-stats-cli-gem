class NbaStats::Scraper # Singleton
  
  def initialize
    @teams = {}
  end

  def open_page(url)
    Nokogiri::HTML(open(url))
  end

  def teams
    if NbaStats::Team.all.empty?
      page = open_page("http://www.basketball-reference.com/leagues/NBA_2016_standings.html")

      @teams[:east] = page.css("table#E_standings td a")
      @teams[:west] = page.css("table#W_standings td a")

      teams_array = assign_teams(:west) + assign_teams(:east)
      NbaStats::Team.create_from_collection(teams_array)
    end
  end

  def assign_teams(conference)
    @teams[conference].collect do |team|
      name = team.text
      team_url = "http://www.basketball-reference.com" + team["href"]
      {name: name, team_url: team_url, conference: conference.to_s.capitalize}
    end.uniq
  end

  def get_roster(team)
    page = open_page(team.team_url)
    players = page.css("table#roster tr")
    players.drop(1).collect do |player|
      data_array = array_maker(player)
      number = data_array[1]
      name = data_array[2]
      position = data_array[3]
      height = data_array[4]
      data_array[8] == "R" ? experience = "Rookie" : experience = data_array[8] + " Years"
      player_url = "http://www.basketball-reference.com" + player.css("a").first["href"]

      {name: name, number: number, position: position, height: height, experience: experience, player_url: player_url}
    end
  end

  def get_player_stats(player)
    page = open_page(player.player_url)

    season = page.css("table#per_game tr.full_table").last
    stats_array = array_maker(season)
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

  def array_maker(element)
    element.text.split("\n").map {|x| x.strip}
  end

end