require 'spec_helper'

describe Mdoc::Processor::AddTitle do
  it 'delete extra blank lines' do
    doc = Mdoc::Document::Kramdown.new('spec/fixtures/multikeys.md')
    doc.body.should match(/^The content inside/)
    doc.apply!('add_title')
    doc.body.should match(/^\# The title for our document/)
  end
end
