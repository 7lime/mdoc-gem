require 'spec_helper'

describe Mdoc do
  it 'pick up source files to convert!' do
    gf = 'spec/fixtures/README.html'
    File.delete(gf) if File.exists?(gf)
    Mdoc.load_cli_options(%w[spec/fixtures/README.md])
    Mdoc.execute!
    File.exists?('spec/fixtures/README.html').should be_true
    File.delete(gf)
  end
end
