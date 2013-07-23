require 'spec_helper'

describe Mdoc::Processor::SmartCodeBlock do
  it 'delete extra blank lines' do
    doc = Mdoc::Document::Kramdown.new('spec/fixtures/README.md')
    doc.body.should match(/~{3,}\s*ruby\s*\n\n+/)
    doc.apply!('smart_code_block')
    doc.body.should_not match(/~{3,}\s*ruby\s*\n\n+/)
  end
end
