require 'spec_helper'

describe RubyDigest::MD5 do
  subject { RubyDigest::MD5 }
  
  describe '.new' do
    it 'returns a new RubyDigest::MD5 instance' do
      expect(subject.new.class).to equal subject
    end
  end
  
  # IETC RFC 1321 tests for the MD5 algorithm.
  # 
  # http://tools.ietf.org/pdf/rfc1321.pdf
  ietc_tests = {
    '' => 'd41d8cd98f00b204e9800998ecf8427e',
    'a' => '0cc175b9c0f1b6a831c399e269772661',
    'abc' => '900150983cd24fb0d6963f7d28e17f72',
    'message digest' => 'f96b697d7cb7938d525a2f31aaf161d0',
    'abcdefghijklmnopqrstuvwxyz' => 'c3fcd3d76192e4007dfb496cca67e13b',
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789' =>
      'd174ab98d277d9f5a5611c2c9f419d9f',
    '1234567890' * 8 => '57edf4a22be3c955ac49da2e2107b67a'
  }
  
  describe '.hexdigest' do
    ietc_tests.each_pair.with_index do |(string, expected), index|
      it "passes IETC RFC 1321 test #{index + 1}" do
        expect(subject.hexdigest(string)).to eql expected
      end
    end
  end
  
  describe '.digest' do
    it 'returns an accurate hash value' do
      expected = "\xF9ki}|\xB7\x93\x8DRZ/1\xAA\xF1a\xD0"
      expect(subject.digest('message digest')).to eq expected
    end
  end
  
  describe '.base64digest' do
    it 'returns an accurate base64-encoded hash value' do
      expected = '+WtpfXy3k41SWi8xqvFh0A=='
      expect(subject.base64digest('message digest')).to eq expected
    end
  end
  
  describe '.file' do
    context 'given a valid file' do
      it 'returns a RubyDigest::MD5 object' do
        md5 = subject.file('spec/assets/test.txt')
        expect(md5.class).to equal subject
      end
      it 'updates the RubyDigest::MD5 object with the file contents' do
        md5 = subject.file('spec/assets/test.txt')
        expect(md5.hexdigest).to eq '2d282102fa671256327d4767ec23bc6b'
      end
    end
    context 'given an invalid file' do
      it 'raises Errno::ENOENT' do
        expect { subject.file('spec/assets/invalid.txt') }.to \
          raise_error Errno::ENOENT
      end
    end
  end
end

describe RubyDigest::MD5 do
  after(:each) { subject.reset }
  
  describe '#initialize' do
    it 'initializes the digest object with an empty state' do
      { :digest => "\xD4\x1D\x8C\xD9\x8F\x00\xB2\x04\xE9\x80\t\x98\xEC\xF8B~",
        :hexdigest => 'd41d8cd98f00b204e9800998ecf8427e',
        :base64digest => '1B2M2Y8AsgTpgAmY7PhCfg=='
      }.each_pair do |type, expected|
        expect(subject.send(type)).to eq expected
      end
    end
  end
  
  describe '#update' do
    context 'given a valid string' do
      it 'updates the internal buffer of the digest object' do
        subject.update('message')
        subject.update(' digest')
        expect(subject.instance_variable_get(:@buffer)).to eq 'message digest'
      end
      it 'returns the digest object' do
        expect(subject.update('message digest')).to equal subject
      end
    end
    context 'given an invalid value' do
      it 'raises a TypeError' do
        expect { subject.update(:"message digest") }.to raise_error TypeError
      end
    end
  end
  
  describe '#<<' do
    it 'is an alias for #update' do
      expect(subject.method(:<<)).to eq subject.method(:update)
    end
  end
  
  describe '#reset' do
    it 'resets the state of the digest object' do
      subject.update('message digest').reset
      expect(subject.instance_variable_get(:@buffer)).to eq ''
    end
    it 'returns the digest object' do
      expect(subject.reset).to equal subject
    end
  end
  
  describe '#block_length' do
    it 'returns 64' do
      expect(subject.block_length).to equal 64
    end
  end
  
  describe '#digest_length' do
    it 'returns 16' do
      expect(subject.digest_length).to equal 16
    end
  end
  
  describe '#length' do
    it 'is an alias for #digest_length' do
      expect(subject.method(:length)).to eq subject.method(:digest_length)
    end
  end
  
  describe '#size' do
    it 'is an alias for #digest_length' do
      expect(subject.method(:size)).to eq subject.method(:digest_length)
    end
  end
  
  describe '#==' do
    context 'compared to a digest object' do
      context 'with the same hash value' do
        it 'returns true' do
          other = subject.class.new
          [other, subject].each { |d| d.update('message digest') }
          expect(subject == other).to equal true
        end
      end
      context 'with a different hash value' do
        it 'returns false' do
          other = subject.class.new
          other.update('message digest')
          expect(subject == other).to equal false
        end
      end
    end
    context 'compared to a string' do
      context 'of the same hex-encoded hash value' do
        it 'returns true' do
          other = 'f96b697d7cb7938d525a2f31aaf161d0'
          subject.update('message digest')
          expect(subject == other).to equal true
        end
      end
      context 'of a different value' do
        it 'returns false' do
          other = 'message digest'
          subject.update('message digest')
          expect(subject == other).to equal false
        end
      end
    end
  end
  
  describe '#base64digest' do
    context 'without a given argument' do
      it 'returns the base64-encoded hash value of the digest object' do
        subject.update('message digest')
        expect(subject.base64digest).to eq '+WtpfXy3k41SWi8xqvFh0A=='
      end
      it 'retains the state of the digest object' do
        subject.update('message digest').base64digest
        expect(subject.base64digest).to eq '+WtpfXy3k41SWi8xqvFh0A=='
      end
    end
    context 'with a given argument' do
      it 'returns the base64-encoded hash value of the given string' do
        subject.update('message digest')
        expect(subject.base64digest('')).to eq '1B2M2Y8AsgTpgAmY7PhCfg=='
      end
      it 'resets the state of the digest object' do
        subject.update('message digest').base64digest('abc')
        expect(subject.base64digest).to eq '1B2M2Y8AsgTpgAmY7PhCfg=='
      end
    end
  end
  
  describe '#base64digest!' do
    it 'returns the base64-encoded hash value of the digest object' do
      subject.update('message digest')
      expect(subject.base64digest!).to eq '+WtpfXy3k41SWi8xqvFh0A=='
    end
    it 'resets the state of the digest object' do
      subject.update('message digest').base64digest!
      expect(subject.base64digest).to eq '1B2M2Y8AsgTpgAmY7PhCfg=='
    end
  end
  
  describe '#digest' do
    context 'without a given argument' do
      it 'returns the hash value of the digest object' do
        expected = "\xF9ki}|\xB7\x93\x8DRZ/1\xAA\xF1a\xD0"
        subject.update('message digest')
        expect(subject.digest).to eq expected
      end
      it 'retains the state of the digest object' do
        expected = "\xF9ki}|\xB7\x93\x8DRZ/1\xAA\xF1a\xD0"
        subject.update('message digest').digest
        expect(subject.digest).to eq expected
      end
    end
    context 'with a given argument' do
      it 'returns the hash value of the given string' do
        expected = "\xD4\x1D\x8C\xD9\x8F\x00\xB2\x04\xE9\x80\t\x98\xEC\xF8B~"
        subject.update('message digest')
        expect(subject.digest('')).to eq expected
      end
      it 'resets the state of the digest object' do
        expected = "\xD4\x1D\x8C\xD9\x8F\x00\xB2\x04\xE9\x80\t\x98\xEC\xF8B~"
        subject.update('message digest').digest('abc')
        expect(subject.digest).to eq expected
      end
    end
  end
  
  describe '#digest!' do
    it 'returns the hash value of the digest object' do
      expected = "\xF9ki}|\xB7\x93\x8DRZ/1\xAA\xF1a\xD0"
      subject.update('message digest')
      expect(subject.digest!).to eq expected
    end
    it 'resets the state of the digest object' do
      expected = "\xD4\x1D\x8C\xD9\x8F\x00\xB2\x04\xE9\x80\t\x98\xEC\xF8B~"
      subject.update('message digest').digest!
      expect(subject.digest).to eq expected
    end
  end
  
  describe '#hexdigest' do
    context 'without a given argument' do
      it 'returns the hex-encoded has value of the digest object' do
        subject.update('message digest')
        expect(subject.hexdigest).to eq 'f96b697d7cb7938d525a2f31aaf161d0'
      end
      it 'retains the state of the digest object' do
        subject.update('message digest').hexdigest
        expect(subject.hexdigest).to eq 'f96b697d7cb7938d525a2f31aaf161d0'
      end
    end
    context 'with a given argument' do
      it 'returns the hex-encoded hash value of the given string' do
        subject.update('message digest')
        expect(subject.hexdigest('')).to eq 'd41d8cd98f00b204e9800998ecf8427e'
      end
      it 'resets the state of the digest object' do
        subject.update('message digest').hexdigest('abc')
        expect(subject.hexdigest).to eq 'd41d8cd98f00b204e9800998ecf8427e'
      end
    end
  end
  
  describe '#hexdigest!' do
    it 'returns the hex-encoded hash value of the digest object' do
      subject.update('message digest')
      expect(subject.hexdigest!).to eq 'f96b697d7cb7938d525a2f31aaf161d0'
    end
    it 'resets the state of the digest object' do
      subject.update('message digest').hexdigest!
      expect(subject.hexdigest).to eq 'd41d8cd98f00b204e9800998ecf8427e'
    end
  end
  
  describe '#finish' do
    it 'is a private method' do
      expect(subject.private_methods).to include :finish
    end
    it 'returns the hash value of the digest object' do
      expected = "\xF9ki}|\xB7\x93\x8DRZ/1\xAA\xF1a\xD0"
      subject.update('message digest')
      expect(subject.send(:finish)).to eq expected
    end
    it 'resets the state of the digest object' do
      subject.update('message digest').send(:finish)
      expect(subject.instance_variable_get(:@buffer)).to eq ''
    end
  end
  
  describe '#file' do
    context 'given a valid file' do
      it 'returns the digest object' do
        expect(subject.file('spec/assets/test.txt')).to equal subject
      end
      it 'updates the RubyDigest::MD5 object with the file contents' do
        subject.file('spec/assets/test.txt')
        expect(subject.hexdigest).to eq '2d282102fa671256327d4767ec23bc6b'
      end
    end
    context 'given an invalid file' do
      it 'raises Errno::ENOENT' do
        expect { subject.file('spec/assets/invalid.txt') }.to \
          raise_error Errno::ENOENT
      end
    end
  end
end
