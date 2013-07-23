require 'spec_helper'

describe Mdoc::Document do
  context 'pandoc style meta header' do
    subject { Mdoc::Document.new('spec/fixtures/pandoc.md') }
    its(:file) { should eq('spec/fixtures/pandoc.md') }
    its(:title) { should eq('Pandoc Title') }
    its(:author) { should eq('Author Like Me') }
    its(:date) { should eq('Date in Some Format') }
    its(:body) { should match(/^The first line of contents/) }
  end

  context 'original style meta header' do
    subject(:doc) { Mdoc::Document.new('spec/fixtures/original.md') }
    its(:title) { should eq('The title for our document') }
    its(:author) { should eq('unknown person') }
    it 'has array and date value assigned' do
      doc.date.strftime('%F').should eq('2009-08-01')
      doc.meta.category[0].should eq('eo.personal')
    end
    its(:body) { should eq("The content inside\n") }
  end

  context 'multikeys style meta header' do
    subject(:doc) { Mdoc::Document.new('spec/fixtures/multikeys.md') }
    its(:file) { should eq('spec/fixtures/multikeys.md') }
    its(:title) { should eq('The title for our document') }
    its(:author) { should eq('unknown person too') }
    it 'has array value assigned' do
      doc.meta.tag[1].should eq('file')
    end
    its(:body) { should eq("The content inside\n") }
  end
end
