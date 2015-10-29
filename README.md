# Mdoc: Markdown to html converter with plug-in processors

Based on kramdown or redcloth, convert markdown to html, with pre/post plug-in processors to implement custom extensions.

## Installation

```ruby
gem install 'mdoc'
```

Or add `gem 'mdoc'` into your `Gemfile`.

## Usage

```ruby
doc = Mdoc.new(line_converters: ClassName, ...)
doc.line_converters << Mdoc::LineConverters::TodoList.new(options ...)
doc.line_converters << Mdoc::LineConverters::SourceSpec.new(options ...)

...

doc.load('some_markdown_file.md')
p doc.source

p doc.pre_converters # call before convert to html

p doc.converter # default: Mdoc::KramdownConverter
doc.convert

p doc.post_converters # called after convert to html

p doc.html
```

## Concept

- Static project document manager live inside the project repository
- Live update with Guard
- Programmatically customizable convert chain
