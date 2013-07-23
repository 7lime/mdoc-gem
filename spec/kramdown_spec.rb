require 'spec_helper'

describe Mdoc::Document::Kramdown do
  describe '#kramdown' do
    subject { Mdoc::Document::Kramdown.new('spec/fixtures/multikeys.md') }
    its(:kramdown) { should_not be_nil }
    its(:body_html) { should match(/<p>The content inside<\/p>/) }
    its(:body_latex) { should match(/The content inside/) }
  end
end
