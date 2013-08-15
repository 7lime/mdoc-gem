module Mdoc
  class Processor
    class Jqplot < Processor
      def process!(doc)
        doc.meta.footer_js_libs << './js/jquery.min.js'
        doc.meta.footer_js_libs << './js/jquery.jqplot.min.js'
        doc.meta.footer_js_libs << './js/plugins/jqplot.categoryAxisRenderer.min.js'
        doc.meta.footer_js_libs << './js/plugins/jqplot.barRenderer.min.js'
        # doc.meta.footer_js_srcs << '$(".diagram").sequenceDiagram({theme: "hand"});'
        new_body = ''
        doc.body.split("\n").each do |line|
          if /^\s*#jqplot#(?<id_>\w+)#(?<title_>.+?)#\s*(?<line_>.+)/ =~ line
            new_body <<-END
  <div id="#{id_}" style="height:400px;width:700px; "></div>
  <script type="text/javascript">
$(document).ready(function(){
    var line_#{id_} = [#{line_}];

    $('##{id_}').jqplot([line_#{id_}], {
        title:'#{title_}',
         seriesDefaults:{
            renderer:$.jqplot.BarRenderer,
            rendererOptions: {
                // Set the varyBarColor option to true to use different colors for each bar.
                // The default series colors are used.
                varyBarColor: true
            }
        },
        axes:{
            xaxis:{
                renderer: $.jqplot.CategoryAxisRenderer
            }
        }
    });
});
  </script>
            END
          else
            new_body << line << "\n"
          end
        end

        doc.body = new_body
      end
    end
  end
end

