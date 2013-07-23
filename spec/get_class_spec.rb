require 'spec_helper'

module Mdoc
  class Processor
    class TestProcessor; end
  end

  class Writer
    class DefaultPrinter; end
  end
end

describe Mdoc do
  describe '.get_class' do
    context 'test_processor for default module' do
      it 'get TestProcessor' do
        klass = Mdoc.get_class('test_processor')
        klass.should eq(Mdoc::Processor::TestProcessor)
      end
    end

    context 'default_printer for writer module' do
      it 'get DefaultPrinter' do
        klass = Mdoc.get_class('default_printer', Mdoc::Writer)
        klass.should eq(Mdoc::Writer::DefaultPrinter)
      end
    end

    context 'non-exists class' do
      it 'return nil' do
        Mdoc.get_class('not_exists').should be_nil
      end
    end
  end
end
