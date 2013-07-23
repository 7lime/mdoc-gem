require 'spec_helper'

describe Mdoc do
  context 'defaults' do
    subject do
      Mdoc.load_defaults
      Mdoc.opts
    end
    its(:template) { should eq('html') }
  end

  context 'load files' do
    subject do
      f_dir = 'spec/fixtures/config'
      f_a, f_b = f_dir + '/mdoc_a.cnf', f_dir + '/mdoc_b.cnf'
      Mdoc.load_conf_files [f_a, f_b]
      Mdoc.opts
    end

    its(:template) { should eq('pandoc.docx') }
  end

  context '--version' do
    subject { capture_stdout { Mdoc.load_cli_options(%w[-v]) } }
    it { should eq(Mdoc::VERSION + "\n") }
  end

  context '--help' do
    subject { capture_stdout { Mdoc.load_cli_options(%w[-h]) } }
    it { should match('-h, --help') }
  end

  context 'cli options' do
    subject(:mopts) do
      # rubocop:disable LineLength
      Mdoc.load_defaults
      Mdoc.load_cli_options(%w[-t xhtml -O -p pa,pb -z na,nb -d de,df fa fb fc])
      Mdoc.opts
      # rubocop:enable LineLength
    end

    its(:no_output) { should be_true }
    its(:template) { should eq('xhtml') }
    its(:processors) { should eq(%w[pa pb]) }
    its(:no_processors) { should eq(%w[na nb]) }
    describe 'tpl directories' do
      it 'has four elements' do
        mopts.tpl_directories.size.should eq(2)
      end

      it 'last elements equals df' do
        mopts.tpl_directories[-1].should match(/df$/)
      end
    end

    describe 'output' do
      it 'can be specified' do
        Mdoc.load_defaults
        Mdoc.load_cli_options(%w[-o specified.html])
        Mdoc.opts.output.should eq('specified.html')
        Mdoc.load_defaults
      end

    end
  end
end
