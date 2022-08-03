require_relative './data_mold'

class Team < DataMold
  attr_reader :data
  attr_accessor :accuracy, :tackles

  def initialize(data)
    super
    @accuracy = {}
    @tackles = {}
  end
end
