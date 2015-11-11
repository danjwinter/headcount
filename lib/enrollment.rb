class Enrollment
  attr_reader :name, :kindergarten_participation

  def initialize(data)
    @data = data
    @name = data.fetch(:name).upcase
    # kindergarten_participation_raw = data.fetch(:kindergarten_participation)
    # @kindergarten_participation = clean_kindergarten_participation_numbers(kindergarten_participation_raw)
    @kindergarten_participation = data.fetch(:kindergarten_participation)
  end

  def clean_kindergarten_participation_numbers(arg)
    arg.each do |k, v|

      if v.is_a?(Numeric) == false
        kindergarten_participation[k] = "N/A"
      end
    end
  end

  def truncate(value)
    ((value * 1000).floor/1000.0) unless value.class == String
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation_by_year[year]
  end

  def kindergarten_participation_by_year
    kindergarten_participation.each do |k, v|
      kindergarten_participation[k] = truncate(v)
    end
  end

end

# e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677})
