module Mdoc
  class Processor
    class AddToc < Processor
      def process!(doc)
        unless doc.body =~ /\{\:toc\}/
          doc.body = "\n* Table of Contents\n{:toc}\n\n" + doc.body
        end
      end
    end
  end
end
