require 'spec_helper'

describe Mdoc do
  it 'find pandoc.html' do
    Mdoc.load_defaults
    Mdoc.load_cli_options %w[-t pandoc.html -d spec/fixtures/templates]
    tpl = Mdoc.find_tpl_file('pandoc.html')
    tpl.should match(%r|spec/fixtures/templates/pandoc\.html\.erb$|)
    Mdoc.find_out_file('ff.md').should eq('ff.html')
  end

  it 'find default.html' do
    Mdoc.load_defaults
    Mdoc.load_cli_options %w[-t html -d spec/fixtures/templates]
    tpl = Mdoc.find_tpl_file('html')
    tpl.should match(%r|spec/fixtures/templates/default\.html\.erb$|)
    Mdoc.find_out_file('ff.md').should eq('ff.html')
  end
end
