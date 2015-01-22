# Mdoc: Markdown to html converter with plug-in processors

Based on kramdown or redcloth, convert markdown to html, with pre/post plug-in processors to implement custom extensions.

## Installation

```ruby
gem install 'mdoc'
```

Or add `gem 'mdoc'` into your `Gemfile`.

## Usage

```ruby
doc = Mdoc.new('some_markdown_file.md')
doc.plugins << Mdoc::Plugins::TodoList.new(...)
doc.before_convert do
  # process some thing on the fly
end
```
