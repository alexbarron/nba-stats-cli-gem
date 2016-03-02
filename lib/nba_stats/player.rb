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
      NbaStats::Player.new(player)
    end
  end

  def self.create_from_collection_with_team(players_array, team)
    players_array.each do |player|
      new_player = NbaStats::Player.new(player)
      new_player.team = team
      team.players << new_player
    end
  end

  def add_player_stats
    stats_hash = NbaStats::Scraper.new.get_player_stats(self)
    stats_hash.each do |key,value|
      self.send("#{key}=", value)
    end
  end

  def stat_rows
    rows = [["Points/Game", "Assists/Game", "Rebounds/Game", "Blocks/Game", "Steals/Game", "FG%", "3P%", "FT%", "Minutes/Game",]]
    rows << [@points_pg, @assists_pg, @rebounds_pg, @blocks_pg, @steals_pg, @fg_percentage, @three_percentage, @ft_percentage, @minutes_pg]
  end

  def self.all
    @@all
  end

  def self.player_names
    @@all.collect {|player| player.name}
  end
end