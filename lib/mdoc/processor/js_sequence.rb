module Mdoc
  class Processor
    class JsSequence < Processor
      def process!(doc)
        doc.meta.footer_js_libs << './js/jquery.min.js'
        doc.meta.footer_js_libs << './js/raphael-min.js'
        doc.meta.footer_js_libs << './js/underscore-min.js'
        doc.meta.footer_js_libs << './js/sequence-diagram-min.js'
        doc.meta.footer_js_srcs << '$(".diagram").sequenceDiagram({theme: "hand"});'
      end
    end
  end
end
