class NbaStats::Team
  
  attr_accessor :name, :team_url, :players, :conference

  @@all = []

  def initialize(team_hash)
    team_hash.each do |key, value|
      self.send("#{key}=", value)
    end
    @players = []
    @@all << self unless @@all.include? self
  end

  def add_players
    players_array = NbaStats::Scraper.new.get_roster(self)
    NbaStats::Player.create_from_collection_with_team(players_array, self)
  end

  def self.create_from_collection(teams_array)
    teams_array.each do |team|
      NbaStats::Team.new(team)
    end
  end

  def self.all
    @@all
  end

  def self.team_names
    @@all.collect {|team| team.name }
  end

  def self.find_by_conference(conference)
    @@all.select {|team| team.conference == conference}
  end

  def self.western_names
    find_by_conference("West").collect {|team| team.name}.sort
  end

  def self.eastern_names
    find_by_conference("East").collect {|team| team.name}.sort
  end

  def self.team_rows
    rows = [["Eastern Conference", "Western Conference"]]

    west_teams = NbaStats::Team.western_names
    east_teams = NbaStats::Team.eastern_names

    rows + 15.times.collect { |i| [east_teams[i], west_teams[i]]}
  end

  def roster_rows
    rows = [["Number", "Name", "Position", "Height", "Experience"]]
    rows + @players.collect do |player|
      [player.number, player.name, player.position, player.height, player.experience]
    end
  end

end