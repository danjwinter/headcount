class District
  attr_accessor :data

  def initialize(data)
    @data = data
  end

  def name
    @data.fetch(:name).upcase
    # {:name => "ACADEMY 20"}
  end

  

end
