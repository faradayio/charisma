module Charisma
  # Various methods for dealing with numbers
  class NumberHelper
    # Delimit a number with commas and return as a string.
    #
    # Adapted from ActionView.
    # @param [Fixnum] number The number to delimit
    # @return [String]
    def self.delimit(number)
      parts = number.to_s.split('.')
      parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
      parts.join('.')
    end
  end
end
