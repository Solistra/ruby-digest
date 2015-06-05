require 'spec_helper'

describe RubyDigest do
  describe '.bubblebabble' do
    it 'properly encodes an empty string' do
      expect(subject.bubblebabble('')).to eql 'xexax'
    end
    
    it 'properly encodes "1234567890"' do
      expected = 'xesef-disof-gytuf-katof-movif-baxux'
      expect(subject.bubblebabble('1234567890')).to eql expected
    end
    
    it 'properly encodes "Pineapple"' do
      expected = 'xigak-nyryk-humil-bosek-sonax'
      expect(subject.bubblebabble('Pineapple')).to eql expected
    end
  end
end

describe RubyDigest::MD5 do
  expected = 'xuvek-ripul-tizor-ligim-tegah-puref-cupuz-cimyt-buxax'
  after(:each) { subject.reset }
  
  describe '.bubblebabble' do
    it 'properly encodes the hash value of the given string' do
      expect(subject.class.bubblebabble('message digest')).to eql expected
    end
  end
  
  describe '#bubblebabble' do
    it 'properly encodes the digest hash value' do
      subject.update('message digest')
      expect(subject.bubblebabble).to eql expected
    end
  end
end
