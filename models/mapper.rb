require 'randexp'

class Mapper
  class << self
    def map
      lowercase_characters = ('a' ..'z').to_a
      uppercase_characters = ('A' ..'Z').to_a
      digits = (0 .. 9).to_a
    
      return (lowercase_characters + uppercase_characters + digits ).sort_by {rand}[0,6].join
    end
  end
end