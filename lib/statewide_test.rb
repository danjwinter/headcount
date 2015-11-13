class UnknownDataError < StandardError
end

class UnkownRaceError < StandardError
end

class StatewideTest
  attr_reader :name, :grade_proficiency

  def initialize(data)
    @name = data.upcase
    @grade_proficiency = {}
  end

  def load_new_data(attribute)
    @grade_proficiency[3] ||= attribute[:third_grade]
    @grade_proficiency[8] ||= attribute[:eighth_grade]
  end

  def proficient_by_grade(number)
    if available_grades.include?(number)
      @grade_proficiency[number]
    else
      raise UnknownDataError
    end
  end

  def available_grades
    [3,8]
  end

  def truncate(value)
    ((value * 1000).floor/1000.0)
  end



end
