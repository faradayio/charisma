module Charisma
  class NumberHelper
    def self.delimit(number)
      parts = number.to_s.split('.')
      parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
      parts.join('.')
    end
  end
end
