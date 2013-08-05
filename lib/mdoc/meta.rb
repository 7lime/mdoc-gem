require 'yaml'
require 'ostruct'

module Mdoc
  ## parsed meta information from the source file
  class Meta < OpenStruct
    def initialize
      super()
      [:header_js_libs, :footer_js_libs, :footer_js_srcs].each do |k|
        send("#{k}=".to_sym, [])
      end
    end

    def load(contents)
      # contents is expected as a hash in yaml format
      YAML.load(contents).each { |k, v| send("#{k}=".to_sym, v) }
      self
    end
  end
end
