require 'spec_helper'

describe RubyDigest do
  describe '.hexencode' do
    it 'encodes the given string in hexadecimal' do
      expect(subject.hexencode('hexencode')).to eql '686578656e636f6465'
    end
  end
end

describe 'Digest' do
  it 'is linked to RubyDigest' do
    expect(Digest).to eq RubyDigest
  end
end

describe 'Main' do
  subject { TOPLEVEL_BINDING }
  
  it 'responds to #RubyDigest' do
    expect(subject.private_methods).to include :RubyDigest
  end
  it 'responds to #Digest' do
    expect(subject.private_methods).to include :Digest
  end
  
  describe '#RubyDigest' do
    context 'given valid input' do
      it 'returns the appropriate constant' do
        expect(RubyDigest('Base')).to eq RubyDigest::Base
      end
    end
    
    context 'given invalid input' do
      it 'raises a NameError' do
        expect { RubyDigest('Invalid') }.to raise_error NameError
      end
    end
  end
end
