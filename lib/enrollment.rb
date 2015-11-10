class Enrollment
  attr_reader :name, :kindergarten_participation

  def initialize(data)
    @data = data
    @name = data.fetch(:name).upcase
    @kindergarten_participation = data.fetch(:kindergarten_participation)
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation_by_year[year]
  end

  def kindergarten_participation_by_year
    kind_part = {}
    @kindergarten_participation.each_pair do |key, value|
      kind_part[key] = ((value * 1000).floor/1000.0)
    end
    kind_part
  end

end

# e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677})
