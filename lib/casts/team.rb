require_relative './data_mold'

class Team < DataMold
  attr_reader :data

  def initialize(data)
    super
  end
end
