require 'spec_helper'

describe Mdoc do
  describe '#find_doc_type' do
    it 'find markdown' do
      Mdoc.find_doc_type('some.md').should eq(Mdoc::Document::Kramdown)
      Mdoc.find_doc_type('some.markdown').should eq(Mdoc::Document::Kramdown)
    end

    it 'default to Document' do

    end
  end
end
