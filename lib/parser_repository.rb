require_relative './kindergarten_enrollment_parser'
require_relative 'high_school_enrollment_parser'
require_relative 'grade_statewide_parser'
require_relative 'race_statewide_parser'
require 'pry'

class ParserRepository
  attr_reader :enrollment_paths, :statewide_paths

  def initialize(file_set)
    @enrollment_paths ||= file_set[:enrollment]
    @statewide_paths ||= file_set[:statewide_testing]
  end

  def parsed
    parsed_category_data = {}
    send_enrollment_data(enrollment_paths, parsed_category_data)

    send_statewide_data(statewide_paths, parsed_category_data)
    parsed_category_data
    binding.pry
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
      file_paths = []
      if category[:third_grade]
        file_paths << [category[:third_grade], :third_grade]
      end
      if category[:eighth_grade]
        file_paths << [category[:eighth_grade], :eighth_grade]
      end
      file_paths
    end
  end

  def race_statewide_path(category)
    if category
      file_paths = []
      if category[:math]
        file_paths << [category[:math], :math]
      end
      if category[:reading]
        file_paths << [category[:reading], :reading]
      end
      if category[:writing]
        file_paths << [category[:writing], :writing]
      end
      file_paths
    end
  end

  def send_to_grade_statewide_parser(statewide, parsed_category_data)
    if grade_statewide_path(statewide)
      gsp = GradeStatewideParser.new
      grade_statewide_path(statewide).each do |path|
        gsp.load_info(path)
      end
      if parsed_category_data[:statewide]
        parsed_category_data[:statewide].merge!(gsp.data_set)
      else
        parsed_category_data[:statewide] = gsp.data_set
      end
    end
  end

  def send_to_race_statewide_parser(statewide, parsed_category_data)
    if race_statewide_path(statewide)
      rsp = RaceStatewideParser.new
      race_statewide_path(statewide).each do |path|
        rsp.load_info(path)
      end

      parsed_category_data[:statewide].each do |k,v|
        
        parsed_category_data[:statewide][k] = [v, rsp.data_set[k]]
      end



      # if parsed_category_data[:statewide]
      #
      #   parsed_category_data[:statewide].merge!(rsp.data_set)
      #
      # else
      #   parsed_category_data[:stateide] = rsp.data_set
      # end
    end

  end

  # def third_grade_statewide_path(category)
  #   category[:third_grade]
  # end

  def send_to_high_school_enrollment_parser(enrollment, parsed_category_data)
    if high_school_path(enrollment)
      if parsed_category_data[:enrollment]
        parsed_category_data[:enrollment].push(HighSchoolEnrollmentParser.new(high_school_path(enrollment)).district_data)
      else
        parsed_category_data[:enrollment] = [HighSchoolEnrollmentParser.new(high_school_path(enrollment)).district_data]
      end
    end
  end

  def high_school_path(category)
    if category
      category[:high_school_graduation]
    end
  end

  def send_to_kindergarten_enrollment_parser(enrollment, parsed_category_data)
    if kindergarten_path(enrollment)
      if parsed_category_data[:enrollment]
        parsed_category_data[:enrollment].push(KindergartenEnrollmentParser.new(kindergarten_path(enrollment)).district_data)
      else
        parsed_category_data[:enrollment] = [KindergartenEnrollmentParser.new(kindergarten_path(enrollment)).district_data]
      end
    end
  end

  def kindergarten_path(category)
    if category
      category[:kindergarten]
    end
  end

end
