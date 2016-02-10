class NbaStats::Team
  
  attr_accessor :name, :team_url, :players, :conference

  @@all = []

  def initialize(team_hash)
    team_hash.each do |key, value|
      self.send("#{key}=", value)
    end
    @players = []
    @@all << self
  end

  def add_players
    players_array = NbaStats::Scraper.get_roster(self)
    NbaStats::Player.create_from_collection_with_team(players_array, self)
  end

  def self.create_from_collection(teams_array)
    teams_array.each do |team|
      new_team = NbaStats::Team.new(team)
    end
  end

  def self.all
    @@all
  end

  def self.team_names
    @@all.collect {|team| team.name }
  end

  def self.western_names
    west = @@all.select {|team| team.conference == "West"}
    names = west.collect {|team| team.name}.sort
  end

  def self.eastern_names
    east = @@all.select {|team| team.conference == "East"}
    east.collect {|team| team.name}.sort
  end

end