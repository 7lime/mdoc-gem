require 'spec_helper'

module Mdoc
  class Processor
    class ProcA < Processor; end
    class ProcB < Processor; end

    class ProcC < Processor
      def process!(doc)
        doc.body = 'c'
      end
    end

    class ProcD < Processor
      def process!(doc)
        doc.body = 'd'
      end
    end

    class ProcR < Processor
      def repeatable?
        true
      end
    end

    class ProcWrap < Processor
      def pre_processors
        [ProcA, 'proc_b']
      end
    end
  end

  class NilWriter < Writer
    def process!(doc); end

    def default_processors
      []
    end
  end
end

describe Mdoc::Pipeline do
  context 'pre_processor' do
    subject(:doc) do
      Mdoc.convert!('spec/fixtures/multikeys.md') do |pl|
        pl.insert('proc_wrap')
        pl.writer = Mdoc::NilWriter
      end
    end

    it 'perform 3 processors' do
      ps = Mdoc.default_processors(Mdoc::Writer).size
      doc.performed.size.should eq(3 + ps)
      doc.performed[Mdoc::Processor::ProcB].should eq(1)
    end
  end

  context 'insert' do
    subject(:doc) do
      Mdoc.convert!('spec/fixtures/multikeys.md') do |pl|
        pl.append('proc_wrap')
        pl.append('proc_c')
        pl.insert('proc_d', { before: 'proc_c' })
      end
    end

    it 'perform 5 processors' do
      doc.is_a?(Mdoc::Document::Kramdown).should be_true
      ps = Mdoc.default_processors(Mdoc::Writer).size
      doc.performed.size.should eq(5 + ps)
      doc.performed[Mdoc::Processor::ProcD].should eq(1)
      doc.performed[Mdoc::Processor::ProcC].should eq(1)
      doc.body.should eq('c') # d insert before c
    end
  end

  context 'repeatable' do
    subject(:doc) do
      Mdoc.convert!('spec/fixtures/general.txt') do |pl|
        pl.insert('proc_a')
        pl.insert('proc_a')
        pl.append('proc_r')
        pl.append('proc_r')
        pl.append('proc_b')
        pl.insert('proc_d', { after: 'proc_b' })
        pl.remove(['proc_b'])
        pl.writer = Mdoc::NilWriter
      end
    end

    it 'repeat only for proc_r' do
      doc.is_a?(Mdoc::Document).should be_true
      doc.performed[Mdoc::Processor::ProcA].should eq(1)
      doc.performed[Mdoc::Processor::ProcR].should eq(2)
      doc.body.should eq('d')
    end
  end

end
