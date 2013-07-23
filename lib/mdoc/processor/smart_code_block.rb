# Delete extra blank lines inside ~~~~~ code bloks
#
# rubocop:disable MethodLength
module Mdoc
  class Processor
    class SmartCodeBlock < Processor
      def process!(doc)
        odd, last, hold = false, false, 0
        new_body = ''
        doc.body.split(/\n/).each do |line|
          if line =~ /^\s*~{3,}\s*\w*\s*/
            hold = 0 if odd
            odd = odd ? false : true
            last = true
          else
            next if last && odd && (line =~ /^\s*$/)

            if line =~ /^\s*$/
              hold += 1 # hold the line
              next
            end

            last = false
          end

          hold.times { new_body << "\n" }
          hold = 0
          new_body << line << "\n"
        end

        doc.body = new_body.chomp
        # puts doc.body
      end
    end
  end
end
# rubocop:enable MethodLength
