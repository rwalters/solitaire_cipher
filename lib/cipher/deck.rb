module Cipher
  class Deck
    START_DECK = ((1..52).to_a + ['A', 'B']).freeze

    attr_reader :current_deck
    def initialize(start_deck = START_DECK)
      @current_deck = start_deck.dup
    end

    def key
      move_joker_a
      move_joker_b
      triple_cut
      number_cut
    end

    def pull
      key
      count_down =
        if current_deck.first.is_a?(String)
          53
        else
          current_deck.first
        end

      c = current_deck[count_down]

      return pull if c.is_a?(String)

      box_to_alpha(c)
    end

    def move_joker_a
      move_joker('A')
    end

    def move_joker_b
      move_joker('B')
      move_joker('B')
    end

    def triple_cut
      jokers = [current_deck.index('A'), current_deck.index('B')].sort

      ary_first = current_deck[0...jokers.first]
      ary_core = current_deck[jokers.first..jokers.last]
      ary_last = current_deck[(jokers.last+1)..-1]

      @current_deck = (ary_last + ary_core + ary_first).freeze

      self
    end

    def number_cut
      cut_val = current_deck.last

      t_deck = current_deck.dup
      t_deck =
        t_deck.slice(cut_val, (t_deck.size-cut_val-1)) \
        + t_deck.slice(0, cut_val) \
        + t_deck.slice(-1,1)

      @current_deck = t_deck.freeze

      self
    end

    def to_a
      current_deck
    end

    private

    def box_to_alpha(num)
      ((num-1) % 26) + 1
    end

    def move_joker(joker)
      start_index = current_deck.index(joker)
      end_index = (start_index%(current_deck.size-1)) + 1

      @current_deck =
        current_deck
        .dup
        .tap do |ary|
          to_move = ary.delete_at(start_index)
          ary.insert(end_index, to_move)
        end.freeze

        self
    end
  end
end
