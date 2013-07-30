# Extend link with ->https ...

module Mdoc
  class Processor
    class ExpandLink < Processor
      def process!(doc)
        new_body = ''
        doc.body.split(/\n/).each do |line|
          new_body << line.gsub(%r!\-\>(https?\://\S+)!, '[\1](\1)') << "\n"
        end
        doc.body = new_body
      end
    end
  end
end
