class District
  attr_accessor :data
  attr_reader :name

  def initialize(data)
    @data = data
  end

  def name
    data.fetch(:name).upcase
  end


end
