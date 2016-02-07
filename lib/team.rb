class Team
  
  attr_accessor :name, :team_url, :players

  @@all = []

  def initialize(team_hash)
    team_hash.each do |key, value|
      self.send("#{key}=", value)
    end
    @players = []
    @@all << self
  end

  def add_players
    players_array = Scraper.get_roster(self)
    Player.create_from_collection_with_team(players_array, self)
  end

  def self.create_from_collection(teams_array)
    teams_array.each do |team|
      new_team = Team.new(team)
    end
  end

  def self.all
    @@all
  end

  def self.team_names
    @@all.collect {|team| team.name }
  end

end