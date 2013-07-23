require 'yaml'
require 'ostruct'

module Mdoc
  ## parsed meta information from the source file
  class Meta < OpenStruct

    def load(contents)
      # contents is expected as a hash in yaml format
      YAML.load(contents).each { |k, v| self.send("#{k}=".to_sym, v) }
      self
    end
  end
end
