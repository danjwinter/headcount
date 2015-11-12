require_relative './kindergarten_enrollment_parser'
require_relative 'high_school_enrollment_parser'
require 'pry'

class ParserRepository
  attr_reader :enrollment

  # def clean_kindergarten_participation_numbers(arg)
  #   arg.each do |k, v|
  #     if v.is_a?(Numeric) == false
  #       kindergarten_participation[k] = "N/A"
  #     end
  #   end
  # end

  def initialize(file_set)
    @enrollment = file_set.fetch(:enrollment)
  end

  def parsed
    parsed_category_data = []
    if kindergarten_path(enrollment)
      parsed_category_data << KindergartenEnrollmentParser.new(kindergarten_path(enrollment)).district_data
    end
    if high_school_path(enrollment)
      parsed_category_data << HighSchoolEnrollmentParser.new(high_school_path(enrollment)).district_data
    end
    parsed_category_data
  end

  def high_school_path(category)
    category[:high_school_graduation]
  end

  def kindergarten_path(category)
    category[:kindergarten]
  end

end
