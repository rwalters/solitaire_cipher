require './lib/cipher/solitaire'

describe Cipher::Solitaire do
  subject { described_class.new }

  describe ".new" do
    it "initializes a deck" do
      expect(subject.deck.nil?).to be_falsey
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

  context "with a different deck" do
    subject { described_class.new(deck) }

    let(:start_deck)  { Cipher::Deck::START_DECK.shuffle }
    let(:deck)        { Cipher::Deck.new(start_deck) }

    let(:plaintext)   { "Code in Ruby, live longer!" }
    let(:decrypted)   { "CODEI NRUBY LIVEL ONGER" }

    it "shows the deck used to instantiate the subject" do
      expect(described_class.new(deck).deck.to_a).to match deck.to_a
    end

    it "encrypts and decrypts to the expected value" do
      encrypted = described_class.new(deck).encrypt(plaintext)

      expect(described_class.new(deck).decrypt(encrypted)).to eq decrypted
    end
  end
end
