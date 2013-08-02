require 'mdoc/version'
require 'mdoc/options'
require 'mdoc/meta'
require 'mdoc/document'
require 'mdoc/document/kramdown'
require 'mdoc/processor'
require 'mdoc/processor/smart_code_block'
require 'mdoc/processor/add_title'
require 'mdoc/processor/add_toc'
require 'mdoc/processor/expand_link'
require 'mdoc/pipeline'
require 'mdoc/writer'
require 'mdoc/writer/pandoc_writer'

# individual processors

module Mdoc
  extend self # act as a class

  # entry point of the application, for each source files
  # read, process and write out to converted file
  def execute!
    load_defaults unless @opts

    opts.s_files.each do |sname|
      Dir[sname].each { |fname| convert!(fname) }
    end
  end

  ## convert single file
  def convert!(fname, doc_type = nil)
    doc = prepare_doc(fname, doc_type)

    # apply pipeline of processors # TODO: separate writer
    writer = find_writer(doc)
    pli = default_pipeline(doc, writer)
    yield pli if block_given? # receive user supplied processors
    pli.writer = writer unless pli.writer

    pli.apply!(doc)
    doc # return doc
  end

  # attr accessor for opts
  def opts
    load_defaults unless @opts
    @opts
  end

  def prepare_doc(fname, doc_type)
    doc_type = find_doc_type(fname) unless doc_type
    doc = doc_type.new(fname)
    # template
    doc.tpl_file = find_tpl_file(opts.template)

    # output file
    doc.out_file = find_out_file(fname) unless opts.no_output
    doc
  end

  # from several directory
  # rubocop:disable MethodLength
  def find_tpl_file(fname)
    # add default search directory
    ipath = File.expand_path(File.dirname(__FILE__) + '/../templates')
    opts.tpl_directories << ipath unless opts.tpl_directories.include?(ipath)
    rpath = File.expand_path('./templates')
    opts.tpl_directories << rpath unless opts.tpl_directories.include?(rpath)

    fname = 'default.' + fname unless fname =~ /\./
    cand, buf = [], nil
    fname.split('.').reverse.each do |b|
      buf = buf ? b + '.' + buf : b
      cand.unshift buf
    end

    cand.each do |pt|
      opts.tpl_directories.each do |d|
        tpl = d + '/' + pt + '.erb'
        return tpl if File.exists?(tpl)
      end
    end

    # raise 'no template file found for ' + opts.template
    nil
  end
  # rubocop:enable MethodLength

  def find_out_file(fname)
    return opts.output if opts.output
    ext = '.' + opts.template.split('.')[-1]
    fname =~ /\.\w{2,5}$/ ? fname.gsub(/\.\w+$/, ext) : fname + ext
  end

  # get class from keyword and module under Mdoc name space
  def get_class(cname, mdl = Processor)
    mdl.const_get(cname.split(/[\,\_]/).map { |p| p.capitalize }.join)
  rescue NameError
    return nil
  end

  def get_processor(pn)
    pname = pn.is_a?(String) ? pn : pn.class
    pn = get_class(pn) if pn.is_a?(String) # for string name
    raise "not a valid class: #{pname.to_s}" unless pn
    raise "not a processor: #{pname.to_s}" unless pn < Mdoc::Processor

    pn
  end

  # from file name (esp. extensions), determine source file document type
  def find_doc_type(f)
    case f
    when /\.(md|markdown)/
      Document::Kramdown
    else Document
    end
  end

  # get a list of processors into a pipline
  def default_pipeline(doc, writer)
    pli = Pipeline.new default_processors(writer)
    opts.processors.each { |p| pli.append p }
    opts.no_processors.each { |p| pli.remove p }
    pli
  end

  def default_processors(writer)
    writer.new.default_processors
  end

  def find_writer(doc)
    case opts.template
    when /pandoc\.\w+$/
      PandocWriter
    when /(epub|docx)/ # no native support
      PandocWriter
    else Writer
    end
  end
end

