require_relative './enrollment_parser'
require 'pry'

class ParserRepository
  attr_reader :enrollment

  def initialize(file_set)
    @enrollment = file_set.fetch(:enrollment)
  end

  def parsed
    if high_school_path(enrollment)
      #send to highschool_parser
    end
    if kindergarten_path(enrollment)
      EnrollmentParser.new(kindergarten_path(enrollment)).district_data
    end
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
