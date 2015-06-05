require 'spec_helper'

describe RubyDigest::SHA1 do
  subject { RubyDigest::SHA1 }
  
  # IETC RFC 3174 tests for the SHA1 algorithm.
  # 
  # http://tools.ietf.org/pdf/rfc3174.pdf
  ietc_tests = {
    'abc' =>
      'a9993e364706816aba3e25717850c26c9cd0d89d',
    'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq' =>
      '84983e441c3bd26ebaae4aa1f95129e5e54670f1',
    'a' =>
      '86f7e437faa5a7fce15d1ddcb9eaeaea377667b8',
    '01234567' * 8 =>
      'e0c094e867ef46c350ef54a7f59dd60bed92ae83'
  }
  
  describe '.hexdigest' do
    ietc_tests.each_pair.with_index do |(string, expected), index|
      it "passes IETC RFC 3174 test #{index + 1}" do
        expect(subject.hexdigest(string)).to eql expected
      end
    end
  end
end

describe RubyDigest::SHA1 do
  describe '#block_length' do
    it 'returns 64' do
      expect(subject.block_length).to equal 64
    end
  end
  
  describe '#digest_length' do
    it 'returns 20' do
      expect(subject.digest_length).to equal 20
    end
  end
end
