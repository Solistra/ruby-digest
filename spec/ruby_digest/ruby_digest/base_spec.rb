require 'spec_helper'

class RubyDigest::BaseWithConstructor < RubyDigest::Base
end

describe RubyDigest::Base do
  subject { RubyDigest::Base }
  
  describe '.new' do
    it 'raises a NotImplementedError' do
      expect { subject.new }.to raise_error NotImplementedError
    end
  end
end
