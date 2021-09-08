require "minitest/autorun"

pattern = File.expand_path('./**/test_*.rb', File.dirname(__FILE__))
Dir.glob(pattern) { |f| require_relative(f) }
