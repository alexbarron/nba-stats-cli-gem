class Scraper

  def open_page(url)
    Nokogiri::HTML(open(url))
  end

  #Creates an array of hashes with current team names and links to 2015-16 team page
  def get_teams
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
end