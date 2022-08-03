require_relative './data_mold'

class GameTeam < DataMold
  attr_reader :data

  def initialize(data)
    super
  end
end
