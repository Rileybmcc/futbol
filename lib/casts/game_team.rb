require_relative './data_mold'

class GameTeam < DataMold
  attr_reader :data, :ids_by_season
  attr_accessor :win_percent

  def initialize(data)
    super
    @win_percent = {}
  end
end
