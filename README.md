
Mdoc-gem
============

A tool for convert document between several different formats.

Mdoc has a modularized structure, easily extensible with custom processors.

## Install

    gem install mdoc

(requires ruby 1.9.x)

## Synopsis

- Convert a markdown file (`readme.md` in this example) to html (use `default.html` template):

    mdoc readme.md

This will create a `readme.html` file besides `readme.md`.

- Convert a markdown file with a custom template:

    mdoc -t custom.html readme.md

Mdoc will try to find `custom.html.erb` from `./templates` folder, or you can specify it by:

    mdoc -t custom.html -d ~/mdoc_templates readme.md

- Specify output filename:

    mdoc -o README.html readme.md

Or print out to STDOUT:

    mdoc -O readme.md

## Markdown with Meta Information

The default source file format is markdown[^1]. Mdoc convert it into a document class
`Mdoc::Document::Kramdown`, with supports all extensions from Kramdown[^2].

[^1]: Wikipedia: ->http://en.wikipedia.org/wiki/Markdown
[^2]: Kramdown Syntax: ->http://kramdown.rubyforge.org/quickref.html

Additionally, you can put meta informations in the begin of your source file, in two
different format:

1. pandoc like three line header (max 3 lines)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % title
    % author
    % date

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

2. multi-header (first non-blank line with three or more dashes)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % ---
    title: some key
    author: some key
    % ---

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The heading `%` is optional. 

You can access those information from erb files by `<%= meta.title %>`

## Processors

The following processors are enabled by default:

- `add_toc`: Add `table of contents` field in the contents body;
- `add_title`: Add a `meta.title` as a first level header in the contents body;
- `smart_code_block`: delete extra heading/trailing blank lines in code blocks;
- `expand_link`: expand `->http ...` to `[http ... ](http ...)` (add hyper link);

You can disable some of the processors by:

    mdoc -z add_toc,smart_code_block readme.md

## Built-in Non-default Processors

- `js_sequnce`: use the following command:

    mdoc -p js_sequence file.md

  to convert:

    a->b: send()
    b->c: send_to()
    c->a: response()

  to UML sequence diagrams with js-sequence-diagrams tools[^3].

[^3]: ->http://bramp.github.io/js-sequence-diagrams/

## Use Mdoc as a Library

~~~~~~~~~~~~~~~~~~~~~~~~~ ruby

    require 'mdoc'
    module Mdoc
      class Processor
        class Custom < Processor
          def process!(document) 
            document.meta.title += ' (draft)' # edit the document title
            document.body.gsub!(/https/, 'http')  # change the source body text
          end

          def repeatable?
            true # default is false
          end
        end

        class Other < Processor
          def process!(document)
            # do some thing ...
          end
        end
      end

      class Writer
        class CustomWriter
          def process!(document)
            # fh.puts ...
          end
        end
      end
    end

    Mdoc.convert!('somefile.md') do |pipeline|
      pipeline.insert :custom # insert into the begin of the processor pipeline
      pipeline.insert :other, :before => :custom # or :after => :some_processor
      pipeline.remove :todo

      pipeline.writer = CustomWriter
    end

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Unless you define a method `repeatable?` and returns `true`, one processor will
process a document at most once.

## Tests

    rubocop && rspec
