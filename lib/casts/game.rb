require_relative './data_mold'

class Game < DataMold
  attr_reader :data

  def initialize(data)
    super
  end
end
