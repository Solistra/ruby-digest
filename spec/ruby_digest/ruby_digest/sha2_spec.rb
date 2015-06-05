require 'spec_helper'

describe RubyDigest::SHA256 do
  subject { RubyDigest::SHA256 }
  
  # IETC RFC 4634 tests for the SHA256 algorithm.
  # 
  # http://tools.ietf.org/pdf/rfc4634.pdf
  ietc_tests = {
    'abc' =>
      'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad',
    'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq' =>
      '248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1',
    ('abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmn' <<
     'hijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu') =>
      'cf5b16a778af8380036ce59e7b0492370b249b11e8f07a51afac45037afee9d1',
    'a' =>
      'ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb',
    '01234567' * 8 =>
      '8182cadb21af0e37c06414ece08e19c65bdb22c396d48ba7341012eea9ffdfdd'
  }
  
  describe '.hexdigest' do
    ietc_tests.each_pair.with_index do |(string, expected), index|
      it "passes IETC RFC 4634 test #{index + 1}" do
        expect(subject.hexdigest(string)).to eql expected
      end
    end
  end
end

describe RubyDigest::SHA256 do
  describe '#block_length' do
    it 'returns 64' do
      expect(subject.block_length).to equal 64
    end
  end
  
  describe '#digest_length' do
    it 'returns 32' do
      expect(subject.digest_length).to equal 32
    end
  end
end
