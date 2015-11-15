require_relative './kindergarten_enrollment_parser'
require_relative 'high_school_enrollment_parser'
require 'pry'

class ParserRepository
  attr_reader :enrollment

  def initialize(file_set)
    @enrollment ||= file_set[:enrollment]
    @statewide ||= file_set[:statewide_testing]
  end

  def parsed
    parsed_category_data = []
    send_enrollment_data(enrollment, parsed_category_data)

    binding.pry

    send_statewide_data(statewide, parsed_category_data)

    parsed_category_data
  end

  def send_enrollment_data(enrollment, parsed_category_data)
    send_to_kindergarten_enrollment_parser(enrollment, parsed_category_data)
    send_to_high_school_enrollment_parser(enrollment, parsed_category_data)
  end

  def send_statewide_data(statewide, parsed_category_data)
    send_to_grade_statewide_parser(statewide, parsed_category_data)

    send_to_race_statewide_parser(statewide, parsed_category_data)
  end

  def grade_statewide_path(category)
    if category
      if category[:third_grade]
        [category[:third_grade], :third_grade]
      elsif category[:eighth_grade]
        [category[:eighth_grade], :eighth_grade]
      end
    end
  end

  def send_to_grade_statewide_parser(statewide, parsed_category_data)
    if grade_statewide_path(statewide)
      parsed_category_data << GradeStatewideParser.new(grade_statewide_path(statewide)).district_data
    end
  end

  def race_statewide_path(category)
    if category
      if category[:math]
        [category[:math], :math]
      elsif category[:reading]
        [category[:reading], :reading]
      elsif category[:writing]
        [category[:writing], :writing]
      end
    end
  end

  def send_to_race_statewide_parser(statewide, parsed_category_data)
    if writing_statewide_path(statewide)
      parsed_category_data << RaceStatewideParser.new(writing_statewide_path(statewide)).district_data
    end
  end

  # def third_grade_statewide_path(category)
  #   category[:third_grade]
  # end

  def send_to_high_school_enrollment_parser(enrollment, parsed_category_data)
    if high_school_path(enrollment)
      parsed_category_data << HighSchoolEnrollmentParser.new(high_school_path(enrollment)).district_data
    end
  end

  def high_school_path(category)
    if category
      category[:high_school_graduation]
    end
  end

  def send_to_kindergarten_enrollment_parser(enrollment, parsed_category_data)
    if kindergarten_path(enrollment)
      parsed_category_data << KindergartenEnrollmentParser.new(kindergarten_path(enrollment)).district_data
    end
  end

  def kindergarten_path(category)
    if category
      category[:kindergarten]
    end
  end

end
