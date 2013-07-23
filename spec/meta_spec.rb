require 'spec_helper'

describe Mdoc::Meta do
  subject { Mdoc::Meta.new.load('title: Undefined Title') }
  its(:title) { should eq('Undefined Title') }
end
