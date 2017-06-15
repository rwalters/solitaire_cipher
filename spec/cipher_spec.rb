require './lib/cipher'

describe Cipher::Cipher do
  subject { described_class.new }

  describe ".new" do
    it "initializes a deck" do
      expect(subject.strategy.nil?).to be_falsey
    end
  end

  describe "#encrypt" do
    let(:plaintext) { "Code in Ruby, live longer!" }
    let(:encrypted) { "GLNCQ MJAFF FVOMB JIYCB" }

    it "encrypts as expected" do
      expect(subject.encrypt(plaintext)).to eq encrypted
    end
  end

  describe "#decrypt" do
    let(:encrypted) { "GLNCQ MJAFF FVOMB JIYCB" }
    let(:decrypted) { "CODEI NRUBY LIVEL ONGER" }

    it "decrypts as expected" do
      expect(subject.decrypt(encrypted)).to eq decrypted
    end
  end
end
