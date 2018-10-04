require './lib/cipher/deck'

module Cipher
  class Solitaire
    # http://rubyquiz.com/quiz1.html
    attr_reader :deck

    def initialize(deck = Deck.new)
      @deck = deck.dup
    end

    def encrypt(text_input)
      scrub(text_input).map do |text_block|
        process(text_block){|c| c + stream }
      end.join(' ')
    end

    def decrypt(text_input)
      scrub(text_input).map do |text_block|
        process(text_block){|c| c - stream }
      end.join(' ')
    end

    private

    def process(text, &block)
      text
        .each_char
        .map(&:ord)
        .map{|c| c - 65}
        .map{|c| block.call(c) }
        .map{|c| c % 26 }
        .map{|c| c + 65}
        .map(&:chr)
        .join('')
    end

    def stream
     deck.pull.to_i
    end

    def scrub(input)
      input
        .upcase
        .tr('^A-Z', '')
        .scan(/.{1,5}/)
        .tap do |ary|
          ary[-1] =
            ("%-5s"%ary.last)
            .tr(' ', 'X')
        end
    end
  end
end
