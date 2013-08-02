module Mdoc
  class Pipeline
    attr_accessor :writer
    attr_reader :processors

    def initialize(ary = [])
      @processors = []
      append ary
    end

    # get processor class in name
    def get_prc(prc)
      prc = [prc] unless prc.is_a?(Array)
      prc.map { |pn| Mdoc.get_processor(pn) }
    end

    def insert(prc, opts = {})
      prc = get_prc(prc)
      raise 'can not set before with after' if opts[:before] && opts[:after]
      ankor = opts[:before] || opts[:after]
      offset = get_offset(opts) if ankor
      ankor ? @processors.insert(offset, *prc) :
              @processors = prc.concat(@processors)
    end

    # from :before, :after, calculate insert offset
    def get_offset(opts)
      phash = Hash[@processors.map.with_index.to_a]
      if opts[:before]
        offset = phash[Mdoc.get_processor(opts[:before])]
      elsif opts[:after]
        offset = phash[Mdoc.get_processor(opts[:after])] + 1
      end
      offset
    end

    def append(prc)
      prc = get_prc(prc)
      prc.each { |p| @processors << p }
    end

    def remove(prc)
      prc = get_prc(prc)
      prc.map { |pn| @processors.delete(pn) }
    end

    def enabled?(prc)
      prc = get_prc(prc)
      @processors.include(prc)
    end

    # recursively apply processors to document
    def apply!(document)
      @processors.each do |pn|
        prc = Mdoc.get_processor(pn)
        prc.new.pre_processors.each { |p| document.apply!(p) }
        document.apply!(prc)
        prc.new.post_processors.each { |p| document.apply!(p) }
      end

      writer.new.process!(document)
    end
  end
end
