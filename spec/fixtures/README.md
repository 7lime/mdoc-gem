# MDOC: general document converting/management tool

Mdoc is a swiss-army-knife kind of tool converting documents between many formats.

## Install

    gem install mdoc

## Features

- Modularized structure, document will passing through a
  pre-defined processor pipe-line during the converting process.

- Easily extensible with custom processors

## Usage

Convert a markdown file (`readme.md`) to html (default template):

    mdoc readme.md

### Customize with your own template

    mdoc -t custom.html.erb readme.md

Will use `custom.html.erb` file as template, you can put this file under
`/etc/mdoc/templates`, `~/.mdoc/templates/` or `./templates`.

Mdoc will first try to use `CustomHtmlWriter`, then `HtmlWriter` then
`Writer` to write out the output file. Which by default is `readme.html`
for the last example, or you can specify your own as:

    mdoc -t custom.html.erb -o README.htm readme.md

Mdoc use a `tilt` based template handling, by default `meta` and
`body` are passed as two local variables. Refer API document of
`Mdoc::Document` and `Mdoc::Document::Kramdown` for more information
available[^1].

[^1]: Kramdown Syntax: http://kramdown.rubyforge.org/quickref.html

### Customize processors

    mdoc -p todo,code -P toc,math readme.md

Will enable `todo` and `code` processor but disable `math` and `toc` processor.

## Extend with custom processors:

Add custom processor is easy

~~~~~~~~~~~~~~~~~~~~~~~~~ ruby

    require 'mdoc'
    module Mdoc
      module Processor
        class Custom < Processor
          def process document
            document.meta.title += ' (draft)' # add postfix to document title
            document.body.gsub!(/https/, '')  # change the source body text
          end

          def repeatable?
            true # default is false
          end
        end

        class Other < Processor
        end
      end
    end

    Mdoc.convert!('somefile.md') do |pipeline|
      pipeline.insert :custom
      pipeline.insert :other, :before => :custom # or :after => :some_processor
      pipeline.remove :todo
    end

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

By default `insert` will insert the new processor to the very begin of the chain,
`append` will add to the last, right before `writer`.

You can also customize the `writer` by

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ruby

    Mdoc.new.convert('somefile.md') do |pipeline|
      pipeline.writer :pandoc_markdown
    end

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Writer and default processor list are listed below. (TODO)

## Meta information in header

Three different formats are supported:

1. pandoc like three line header (max 3 lines)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % title
    % author
    % date

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

2. multi-header (first non-blank line with three or more dashes)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    ---- #
    Title: some key
    Author: some key
    ---- #

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

And you can use a optional `%`, so the following is the same as above:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % ---
    Title: some key
    Author: some key
    % ---

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

3. no-header: file directly start with a document header.

Contents below header (except blank lines) are treated as body.

