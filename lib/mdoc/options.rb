require 'optparse'

module Mdoc

  # default configurations
  # rubocop:disable MethodLength
  def load_defaults
    hsh = {
      template: 'html',
      output: nil,
      no_output: false,
      processors: [],
      no_processors: [],
      tpl_directories: [],
      s_files: [],
    }

    # create a dynamic struct with default values
    @opts = Struct.new(*hsh.keys).new(*hsh.values)
  end
  # rubocop:enable MethodLength

  # load configuration files (if exists)
  # from a list of candidates
  def load_conf_files(file_ary)
    load_defaults unless opts

    file_ary.each do |file|
      yml = YAML.load(File.open(file, 'r:utf-8').read) if File.exists? file
      set_option! yml if yml
    end
  end

  # load command line options
  # rubocop:disable LineLength, MethodLength
  def load_cli_options(argv = ARGV)
    load_defaults unless opts
    argv = %w[-h] if argv.size == 0

    OptionParser.new do |opts|
      opts.banner = 'Usage: mdoc [options] file.md [file2.md]'
      opts.separator ''
      opts.separator 'Options: '

      opts.on('-t TPL', '--template TPL', 'output file template') do |tpl|
        set_option!({ template: tpl })
      end

      opts.on('-o FILE', '--output FILE', 'output file template') do |file|
        set_option!({ output: file })
      end

      opts.on('-p P,P2', '--processors P,P2', 'enable processors') do |p|
        p.split(',').each do |pr|
          @opts.processors << pr unless @opts.processors.include?(pr)
        end
      end

      opts.on('-z P,P2', '--disable P,P2', 'disable processors') do |op|
        op.split(',').each do |pr|
          @opts.no_processors << pr unless @opts.processors.include?(pr)
        end
      end

      opts.on('-d D,D2', '--template_directories D,D2', 'directories for finding template') do |d|
        d.split(',').each do |dir|
          dir = File.expand_path(dir)
          @opts.tpl_directories << dir unless @opts.tpl_directories.include?(dir)
        end
      end

      opts.on('-O', '--no-output', 'dump result to STDOUT') do
        @opts.no_output = true
      end

      opts.on_tail('-v', '--version', 'show mdoc version') do
        puts Mdoc::VERSION
        exit
      end

      opts.on_tail('-h', '--help', 'display this screen') do
        puts opts
        exit
      end

    end.parse!(argv)

    set_option!({ s_files: argv })

    # check consistency for related options
    raise 'you can not specify output file when there are more than on source files.' if opts.output && opts.s_files.size > 0
    raise 'you can not speficy output file with --no-output option' if opts.output && opts.no_output
  end
  # rubocop:enable LineLength, MethodLength

  private

  # set options from a hash, raise errors
  # if a key not exists in default hash
  def set_option!(hsh)
    hsh.each { |k, v| @opts.send(:"#{k}=", v) }
  end

end
