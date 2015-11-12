require_relative './kindergarten_enrollment_parser'
require 'pry'

class ParserRepository
  attr_reader :enrollment

  def initialize(file_set)
    @enrollment = file_set.fetch(:enrollment)
  end

  def parsed
    parsed_category_data = []
    if kindergarten_path(enrollment)
      parsed_category_data << KindergartenEnrollmentParser.new(kindergarten_path(enrollment)).district_data
    end
    if high_school_path(enrollment)
      # parsed_category_data << EnrollmentParser.new(high_school_path(enrollment)).high_school_district_data
    end
    parsed_category_data
  end


  def high_school_path(category)
    category[:high_school_graduation]
  end

  def kindergarten_path(category)
    category[:kindergarten]
  end




  # def parsed_path(file_set)
  #   file_set.fetch(:enrollment).fetch(:kindergarten)
  # end


end