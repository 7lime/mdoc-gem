module Mdoc
  # delegate output to pandoc (assume pandoc in path)
  class PandocWriter < Writer
    def out(doc)
      @tmp_file = doc.out_file + '.temp__'
      Mdoc.opts.no_output ? $stdout : File.new(@tmp_file, 'wb')
    end

    def process!(doc)
      @tilt = Tilt::ERBTemplate.new(Mdoc.find_tpl_file('pandoc.md'))
      oh = out(doc)
      oh.write @tilt.render(doc)
      unless oh == $stdout
        oh.close
        `pandoc -o #{doc.out_file} #{@tmp_file}`
        File.delete @tmp_file
      end
    end
  end
end
