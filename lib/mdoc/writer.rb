require 'tilt/erb'

module Mdoc
  class Writer
    attr_accessor :tilt

    def out(doc)
      Mdoc.opts.no_output ? $stdout : File.new(doc.out_file, 'w:utf-8')
    end

    def process!(doc)
      @tilt = Tilt::ERBTemplate.new(doc.tpl_file)
      oh = out(doc)
      oh.write @tilt.render doc
      oh.close unless oh == $stdout
    end
  end
end
