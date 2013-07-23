require 'forwardable'

module Mdoc
  class Document

    LOOP_MAX = 99

    extend Forwardable
    attr_accessor :file, :meta, :body, :tpl_file, :out_file,
                  :smeta, # meta from source file
                  :performed # performed processor

    # rubocop:disable MethodLength
    def initialize(path)
      if path.is_a?(String)
        @file = path
        path = File.new(@file, 'r:utf-8')
      end

      # initialize performed processor list
      @performed = {}

      position = nil # before meta, :meta, :body, :between, :pandoc_header
      pandoc_meta, raw_meta = [], ''
      @meta, @body = Meta.new, ''
      path.each do |line|
        # puts position.to_s + line if position
        line.chomp!

        if line.match(/^\s*$/)
          next if position.nil? || position == :between
        else
          position = :body if position == :between
        end

        if line.match(/^\%?\s*\-{3,}\s*$/) # meta headers
          position = :between if position == :meta
          position = :meta unless position
          next
        elsif line.match(/^\%\s*/)
          position = :pandoc_header if position.nil?
        else
          position = :body unless position # if position == :pandoc_header
        end

        if position == :pandoc_header
          pandoc_meta << line.gsub(/^\%\s*/, '')
          position = :between if pandoc_meta.size >= 3
        end

        raw_meta << line << "\n" if position == :meta
        @body << line << "\n" if position == :body
      end

      @meta.load(raw_meta) if raw_meta.size > 0
      if pandoc_meta.size > 0
        @meta.title, @meta.author, @meta.date = pandoc_meta[0 .. 2]
      end

      # source meta holds meta information from source file only
      @smeta = @meta.dup
    end
    # rubocop:ensable MethodLength

    # apply processors by processor name (if corresponding processor)
    # class defined.
    # rubocop:disable MethodLength
    def apply!(pn)
      prc = Mdoc.get_processor(pn)
      if performed[prc]
        if prc.new.repeatable?
          prc.new.process! self
          performed[prc] += 1
          # error if performed too many times (prevent dead loop)
          raise "loop max reached: #{prc}" if performed[prc] > LOOP_MAX
        end
      else # not performed
        prc.new.process! self
        performed[prc] = 1
      end
    end
    # rubocop:enable MethodLength

    def_delegators :@meta, :title, :author, :date

  end
end
