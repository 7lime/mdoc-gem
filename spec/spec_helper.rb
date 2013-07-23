require 'simplecov'
SimpleCov.start do
  add_group 'Libraries', 'lib'
  add_group 'Specs', 'spec'
  coverage_dir 'docs/coverage'
end

require 'rspec'
require 'mdoc'

def capture_stdout(&block)
  original_stdout = $stdout
  $stdout = fake = StringIO.new
  begin
    yield
  rescue SystemExit
    $stdout = original_stdout # fake rubocop
  ensure
    $stdout = original_stdout
  end
  fake.string
end

def capture_stderr(&block)
  original_stdout = $stderr
  $stderr = fake = StringIO.new
  begin
    yield
  rescue SystemExit
    $stdout = original_stdout # fake rubocop
  ensure
    $stderr = original_stdout
  end
  fake.string
end

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end
