require 'kramdown'

module Mdoc
  class Document
    class Kramdown < Document
      def kramdown
        # TODO: toc and other preprocessors
        @kramdown = ::Kramdown::Document.new(@body) unless @kramdown
        @kramdown
      end

      def body_html
        kramdown.to_html
      end

      def body_latex
        kramdown.to_latex
      end

      alias_method :body_tex, :body_latex
      alias_method :to_latex, :body_latex
      alias_method :to_html, :body_html
    end
  end
end
