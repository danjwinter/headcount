class Enrollment
  attr_reader :name

  def initialize(data)
    @data = data
  end

  def name
    @data.fetch(:name).upcase
  end

end


# e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677})
