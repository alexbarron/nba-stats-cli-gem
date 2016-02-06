class Player
  attr_accessor :name, :number, :player_url, :position, :height, :experience, :points_pg, :assists_pg, :rebounds_pg, :blocks_pg, :steals_pg, :minutes_pg, :fg_percentage, :three_percentage, :ft_percentage

  @@all = []
  def initialize(player_hash)
    player_hash.each do |key, value|
      self.send("#{key}=", value)
    end
    @@all << self
  end

  def self.create_from_collection(players_array)
    players_array.each do |player|
      new_player = Player.new(player)
    end
  end

  def self.all
    @@all
  end
end