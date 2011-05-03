module Immediate
  def to_s
    if @charisma
      Charisma::Curator::Curation::Proxy.new(self).to_s
    else
      super
    end
  end
end

class Fixnum
  include Immediate
end
