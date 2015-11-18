class Enrollment
  attr_reader :name, :kindergarten_participation, :graduation_rate_by_year

  def initialize(data)
      @name = data[:name].upcase
      @kindergarten_participation ||= data[:kindergarten_participation]
      @graduation_rate_by_year ||= data[:high_school_graduation]
  end

  def truncate(value)
    ((value * 1000).floor/1000.0) unless value.class == String
  end

  def kindergarten_participation_in_year(year)
    # binding.pry
    truncate(kindergarten_participation[year])
    # kindergarten_participation_by_year[year]
  end

  def graduation_rate_in_year(year)
    graduation_rate_by_year[year]
  end

  def kindergarten_participation_by_year
    kindergarten_participation.map do |k, v|
       [k, truncate(v)]
    end.to_h
  end

  def load_new_data(attribute)
    @kindergarten_participation ||= attribute[:kindergarten_participation]
    @graduation_rate_by_year ||= attribute[:high_school_graduation]
  end

end
