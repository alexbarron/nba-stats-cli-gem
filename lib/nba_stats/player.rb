class NbaStats::Player
  attr_accessor :name, :team, :number, :player_url, :position, :height, :experience, :points_pg, :assists_pg, :rebounds_pg, :blocks_pg, :steals_pg, :minutes_pg, :fg_percentage, :three_percentage, :ft_percentage

  @@all = []
  def initialize(player_hash)
    player_hash.each do |key, value|
      self.send("#{key}=", value)
    end
    @@all << self
  end

  def self.create_from_collection(players_array)
    players_array.each do |player|
      new_player = NbaStats::Player.new(player)
    end
  end

  def self.create_from_collection_with_team(players_array, team)
    players_array.each do |player|
      new_player = NbaStats::Player.new(player)
      new_player.team = team
      team.players << new_player
    end
  end

  def add_player_stats(stats_hash)
    stats_hash.each do |key,value|
      self.send("#{key}=", value)
    end
  end

  def self.all
    @@all
  end

  def self.player_names
    @@all.collect {|player| player.name}
  end
end