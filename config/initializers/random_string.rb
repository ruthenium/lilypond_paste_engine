class String # Monkey patching is bad, yeah.
  class << self
    AsciiAlphanum = [0..9, 'a'..'z', 'A'..'Z'].map(&:to_a).flatten

    def random(length=0)
      # Note! Ruby version > 1.9 required for Array#sample
      AsciiAlphanum.sample(length).join
      # SecureRandom.hex(3)
    end # random
  end # class << self
end # class String