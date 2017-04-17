require './lib/cipher/deck'

describe Cipher::Deck do
  subject { described_class.new }

  context "default" do
    it "initializes the deck" do
      expect(subject.current_deck).to eq Cipher::Deck::START_DECK
    end
  end

  describe "#key" do
    it "moves the cards in the expected order" do
      expect(subject).to receive(:move_joker_a).ordered
      expect(subject).to receive(:move_joker_b).ordered
      expect(subject).to receive(:triple_cut).ordered
      expect(subject).to receive(:number_cut).ordered

      subject.key
    end
  end

  describe "#pull" do
    let(:result) { %w(4 23 10 24 8 25 18 6 4 7 20 13 19 8 16 21 21 18 24 10).map(&:to_i) }

    it "returns a character from the keystream" do
      output = []
      result.size.times do |i|
        output << subject.pull
      end

      expect(output).to eq result
    end
  end

  context "when given a starting deck" do
    let(:start_deck) { [1,2,3,4,'A','B'] }

    subject { described_class.new(start_deck) }

    it "initializes the deck" do
      expect(subject.current_deck).to eq(start_deck)
    end

    describe "#move_joker_a" do
      context "'A' is one from the bottom card" do
        it "swaps 'B' and 'A'" do
          subject.move_joker_a
          expect(subject.current_deck).to eq([1,2,3,4,'B','A'])
        end
      end

      context "'A' is the bottom card" do
        let(:start_deck) { [1,2,3,4,'B','A'] }

        it "places 'A' after the first card" do
          subject.move_joker_a
          expect(subject.current_deck).to eq([1,'A',2,3,4,'B'])
        end
      end
    end

    describe "#move_joker_b" do
      context "'B' is the bottom card" do
        it "'B' is moved after second card" do
          subject.move_joker_b
          expect(subject.current_deck).to eq([1,2,'B',3,4,'A'])
        end
      end

      context "'A' is the bottom card" do
        let(:start_deck) { [1,2,3,4,'B','A'] }

        it "'B' is moved to after the first card" do
          subject.move_joker_b
          expect(subject.current_deck).to eq([1,'B',2,3,4,'A'])
        end
      end
    end

    describe "#triple_cut" do
      before do
        subject.triple_cut
      end

      context "no cards after 'A'" do
        let(:start_deck) { [1,2,'B',3,4,'A'] }

        it "moves cards from before 'B' to after 'A'" do
          expect(subject.current_deck).to eq(['B',3,4,'A',1,2])
        end
      end

      context "no cards before 'B'" do
        let(:start_deck) { ['B',3,4,'A',1,2] }

        it "moves cards from after 'A' to before 'B'" do
          expect(subject.current_deck).to eq([1,2,'B',3,4,'A'])
        end
      end

      context "cards at both ends" do
        let(:start_deck) { [1,2,'B',3,'A',4,5] }

        it "swap card blocks" do
          expect(subject.current_deck).to eq([4,5,'B',3,'A',1,2])
        end
      end
    end

    describe "#number_cut" do
      context "with a legal deck" do
        before do
          subject.number_cut
        end

        context "a '1' card at the bottom of the deck" do
          let(:start_deck) { [2,'B',3,4,'A',1] }

          it "moves the top card to one before the bottom card" do
            expect(subject.current_deck).to eq(['B',3,4,'A',2,1])
          end
        end

        context "a '2' card at the bottom of the deck" do
          let(:start_deck) { [1,'B',3,4,'A',2] }

          it "moves the two top cards to one before the bottom card" do
            expect(subject.current_deck).to eq([3,4,'A',1,'B',2])
          end
        end
      end

      context "with a joker the bottom of the deck" do
        let(:start_deck) { [1,3,4,'A',2,'B'] }

        it "moves the two top cards to one before the bottom card" do
          expect{ subject.number_cut }.to raise_error(TypeError)
        end
      end
    end
  end
end
