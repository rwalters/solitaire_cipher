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
        text_block
          .each_byte
          .map{|c|c-65}
          .map{|c|c + stream}
          .map{|c|c%26 }
          .map{|c|c+65}
          .map(&:chr)
          .join('')
      end.join(' ')
    end

    def decrypt(text_input)
      text_input
        .split(' ')
        .map do |text_block|
          text_block
            .each_byte
            .map{|c|c-65}
            .map{|c|c - stream}
            .map{|c|c%26 }
            .map{|c|c+65}
            .map(&:chr)
            .join('')
        end.join(' ')
    end

    private

    def stream
     deck.pull.to_i
    end

    def scrub(input)
      input
        .upcase
        .tr('^A-z', '')
        .gsub(/(\w{5})/,'\1 ')
        .split(' ')
        .tap do |ary|
          ary[-1] =
            ("%-5s"%ary.last)
            .tr(' ', 'X')
        end
    end
  end
end
