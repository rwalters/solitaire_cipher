require './lib/cipher/deck'
require './lib/cipher/solitaire'

module Cipher
  class Cipher
    # http://rubyquiz.com/quiz1.html
    attr_reader :strategy

    def initialize(strategy = ::Cipher::Solitaire.new)
      @strategy = strategy
    end

    def encrypt(text_input)
      strategy.encrypt(text_input)
    end

    def decrypt(text_input)
      strategy.decrypt(text_input)
    end
  end
end
