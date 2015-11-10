class District
  attr_accessor :data
  attr_reader :name

  def initialize(name, data)
    @data = data
    @name = name.upcase
  end



end
