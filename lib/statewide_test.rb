class UnknownDataError < StandardError
end

class UnknownRaceError < StandardError
end

class StatewideTest
  attr_reader :name, :grade_proficiency

  def initialize(data)
    @name = data.upcase
    @grade_proficiency = {}
    @race_stats = {}
  end

  def load_new_data(attribute)
    grab_that_grade_proficiency(attribute)
    grab_that_race(attribute)
  end

  def grab_that_grade_proficiency(attribute)
    @grade_proficiency[3] ||= attribute[:third_grade]
    @grade_proficiency[8] ||= attribute[:eighth_grade]
  end

  def grab_that_race(attribute)
    @race_stats[:asian] ||= attribute[:asian]
    @race_stats[:black] ||= attribute[:black]
    @race_stats[:pacific_islander] ||= attribute[:pacific_islander]
    @race_stats[:hispanic] ||= attribute[:hispanic]
    @race_stats[:native_american] ||= attribute[:native_american]
    @race_stats[:white] ||= attribute[:white]
    @race_stats[:two_or_more] ||= attribute[:two_or_more]
  end

  def proficient_by_race_or_ethnicity(race)
    if available_races.include?(race)
      hash_access(@race_stats[race])
    else
      raise UnknownRaceError
    end
  end

  def available_races
    [:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white]
  end

  def proficient_by_grade(number)
    if available_grades.include?(number)
      hash_access(@grade_proficiency[number])
    else
      raise UnknownDataError
    end
  end

  def hash_access(value)
    new_value = {}
    value.each do |key, value|
      new_value[key] = value.each do |next_key, next_value|
        value[next_key] = truncate(next_value)
      end
    end
    new_value
  end

  def available_grades
    [3,8]
  end

  def truncate(value)
    ((value * 1000).floor/1000.0)
  end



end
