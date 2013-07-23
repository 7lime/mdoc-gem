require 'spec_helper'

describe Mdoc::Processor::AddToc do
  it 'delete extra blank lines' do
    doc = Mdoc::Document::Kramdown.new('spec/fixtures/multikeys.md')
    doc.body.should_not match(/\:toc/)
    doc.apply!('add_toc')
    doc.apply!('add_title')
    doc.body.should match(/\:toc/)
  end
end

