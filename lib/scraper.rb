class Scraper

  def self.open_page(url)
    Nokogiri::HTML(open(url))
  end

  # Returns an array of hashes with current team names and links to 2015-16 team page
  def self.get_teams
    page = open_page("http://www.basketball-reference.com/teams")
    teams_array = []
    teams = page.css("table#active tr.full_table a")
    teams.each do |team|
      name = team.text
      team_url = "http://www.basketball-reference.com"+ team["href"] + "2016.html"
      hash = {name: name, team_url: team_url}
      teams_array << hash
    end
    teams_array
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

      #Below is messy workaround
      #Cleaner player.css("a").first["href"] works outside of .each loop, but returns "undefined method '[]' for nil" inside .each
      player_url = player.css("a").map {|element| element["href"]}.first
      player_url = "http://www.basketball-reference.com" + player_url.to_s

      hash = {name: name, number: number, position: position, height: height, experience: experience, player_url: player_url}
      players_array << hash
    end
    players_array
  end


end