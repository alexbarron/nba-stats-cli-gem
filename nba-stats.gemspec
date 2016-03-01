Gem::Specification.new do |s|
  s.name        = 'nba-stats'
  s.version     = '0.1.4'
  s.date        = '2016-02-11'
  s.summary     = "Lookup NBA Player Stats"
  s.description = "A command line interface for looking up 2015-16 NBA player stats"
  s.authors     = ["Alex Barron"]
  s.email       = 'alexbarron@gmail.com'
  s.files       = ["lib/nba_stats.rb", "lib/nba_stats/cli.rb", "lib/nba_stats/player.rb", "lib/nba_stats/team.rb", "lib/nba_stats/scraper.rb", "config/environment.rb"]
  s.homepage    = 'https://github.com/alexbarron/nba-stats-cli-gem'
  s.license     = 'MIT'
  s.executables << 'nba-stats'

  
  s.add_development_dependency "pry", ">= 0"
  s.add_development_dependency "rake", ">= 1.10"
  s.add_development_dependency "rspec", ">= 3.0"
  s.add_dependency "bundler", "~> 1.10"
  s.add_dependency "nokogiri", ">= 0"
  s.add_dependency "term-ansicolor", ">= 0"
  s.add_dependency "terminal-table", "1.5.2"
end