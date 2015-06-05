require 'spec_helper'

class RubyDigest::InstancedClass
  include RubyDigest::Instance
end

describe RubyDigest::Instance do
  subject { RubyDigest::InstancedClass.new }
  
  [:block_length, :digest_length, :finish, :reset].each do |method|
    describe "##{method}" do
      it 'raises a RuntimeError' do
        expect { subject.send(method) }.to raise_error RuntimeError
      end
    end
  end
  
  describe '#update' do
    context 'with an argument given' do
      it 'raises a RuntimeError' do
        expect { subject.update('test') }.to raise_error RuntimeError
      end
    end
    context 'without an argument given' do
      it 'raises an ArgumentError' do
        expect { subject.update }.to raise_error ArgumentError
      end
    end
  end
end
