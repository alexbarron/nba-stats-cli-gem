class Team
  
  attr_accessor :name, :team_url, :roster

  @@all = []

  def initialize(team_hash)
    team_hash.each do |key, value|
      self.send("#{key}=", value)
    end
    @@all << self
  end

  def self.create_from_collection(teams_array)
    teams_array.each do |team|
      new_team = Team.new(team)
    end
  end

  def self.all
    @@all
  end

end