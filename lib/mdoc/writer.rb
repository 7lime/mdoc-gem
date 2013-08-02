require 'tilt/erb'

module Mdoc
  class Writer
    attr_accessor :tilt

    def out(doc)
      Mdoc.opts.no_output ? $stdout : File.new(doc.out_file, 'wb')
    end

    def process!(doc)
      @tilt = Tilt::ERBTemplate.new(doc.tpl_file)
      oh = out(doc)
      oh.write @tilt.render(doc)
      oh.close unless oh == $stdout
    end

    def default_processors
      %w[
        add_toc
        add_title
        smart_code_block
        expand_link
      ]
    end
  end
end
