module Mdoc
  class Processor
    class AddTitle < Processor
      def process!(doc)
        title = doc.title
        if title
          unless doc.body =~ /^\s*\#*\s*#{title}/
            title = '# ' + title + "\n\n"
            doc.body = title + doc.body
          end
        end
      end
    end
  end
end
