class DataMold
  attr_reader :data

  def initialize(data)
    @data = CSV.read(data, { headers: true, header_converters: :symbol })
  end
end
