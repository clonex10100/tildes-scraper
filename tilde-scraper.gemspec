require_relative './lib/tilde_scraper/version'

Gem::Specification.new do |s|
  s.name        = 'tilde-scraper'
  s.version     = TildeScraper::VERSION
  s.date        = '2019-10-05'
  s.summary     = "Scrapes the website tildes.net"
  s.description = "Scrapes the website tildes.net"
  s.authors     = ["Noah Evans"]
  s.email       = 'noah@nevans.me'
  s.files       = [
                    "config/enviornment.rb",
                    "lib/tilde_scraper.rb",
                    "lib/tilde_scraper/api.rb",
                    "lib/tilde_scraper/cli.rb",
                    "lib/tilde_scraper/comment.rb",
                    "lib/tilde_scraper/group.rb",
                    "lib/tilde_scraper/page.rb",
                    "lib/tilde_scraper/scraper.rb",
                    "lib/tilde_scraper/concerns/memorable.rb",
                    "lib/tilde_scraper/topic/topic.rb",
                    "lib/tilde_scraper/topic/link_topic.rb",
                    "lib/tilde_scraper/topic/text_topic.rb"
                  ]
  s.homepage    = 'http://rubygems.org/gems/tildes-scraper'
  s.license     = 'MIT'
  s.executables << 'cli'

  s.add_development_dependency "bundler"
  s.add_development_dependency "nokogiri"
  s.add_development_dependency "pry"
  s.add_development_dependency "require_all"
end
