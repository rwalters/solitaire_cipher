require './lib/cipher'

describe Cipher::Solitaire do
  subject { described_class.new(plaintext) }

  describe ".new" do
    let(:plaintext)       { "Code in Ruby, live longer!" }
    let(:scrubbed_value)  { "CODEI NRUBY LIVEL ONGER".split(' ') }

    it "scrubs the input" do
      expect(subject.plaintext).to eq scrubbed_value
    end

    it "initializes a deck" do
      expect(subject.deck.nil?).to be_falsey
    end

    context "plaintext is not divisible by 5" do
      let(:plaintext)       { "Code in Ruby, live long!" }
      let(:scrubbed_value)  { "CODEI NRUBY LIVEL ONGXX".split(' ') }

      it "fills out to 5 with 'X'" do
        expect(subject.plaintext).to eq scrubbed_value
      end
    end
  end

  describe "#encrypt" do
    let(:plaintext) { "Code in Ruby, live longer!" }
    let(:encrypted) { "GLNCQ MJAFF FVOMB JIYCB" }
    let(:decrypted) { "CODEI NRUBY LIVEL ONGER".split(' ') }

    it "encrypts as expected" do
      expect(subject.encrypt).to eq encrypted
    end
  end
end
