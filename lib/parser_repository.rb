require_relative 'kindergarten_enrollment_parser'
require_relative 'high_school_enrollment_parser'
require_relative 'grade_statewide_parser'
require_relative 'race_statewide_parser'
require_relative 'poverty_parser'
require_relative 'title_i_parser'
require_relative 'free_reduced_lunch_parser'
require_relative 'median_household_income_parser'
require 'pry'

class ParserRepository
  attr_reader :enrollment_paths, :statewide_paths, :economic_paths

  def initialize(file_set)
    @enrollment_paths ||= file_set[:enrollment]
    @statewide_paths ||= file_set[:statewide_testing]
    @economic_paths ||= file_set[:economic_profile]
  end

  def parsed
    parsed_category_data = {}

    send_enrollment_data(enrollment_paths, parsed_category_data)
    send_statewide_data(statewide_paths, parsed_category_data)
    # binding.pry
    send_economic_data(economic_paths, parsed_category_data)

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

  def send_economic_data(economic, parsed_category_data)
    # parsed_category_data[:economic_profile] = {}
    # binding.pry
    e_path = economic_statewide_path(economic)
    if e_path != {}
      if e_path[:median_household_income]
        mhip = MedianHouseholdIncomeParser.new
        mhip.load_info([e_path[:median_household_income], :median_household_income])
        if parsed_category_data[:economic_profile]
          parsed_category_data[:economic_profile].map do |k,v|
            [k, (v.merge!(mhip.data_set[k]))]
          end.to_h
        else
          parsed_category_data[:economic_profile] = mhip.data_set
        end
      end
      if e_path[:children_in_poverty]
        cip = PovertyParser.new
        cip.load_info([e_path[:children_in_poverty], :children_in_poverty])
        if parsed_category_data[:economic_profile]

          parsed_category_data[:economic_profile].map do |k,v|
            # binding.pry
            if cip.data_set[k]
              [k, (v.merge!(cip.data_set[k]))]
            else
              [k, v]
            end
          end.to_h
        else
          parsed_category_data[:economic_profile] = cip.data_set
        end
      end
      if e_path[:free_or_reduced_price_lunch]
        flp = FreeReducedLunchParser.new
        flp.load_info([e_path[:free_or_reduced_price_lunch], :free_or_reduced_price_lunch])
        if parsed_category_data[:economic_profile]
          parsed_category_data[:economic_profile].map do |k,v|
            [k, (v.merge!(flp.data_set[k]))]
          end.to_h
        else
          parsed_category_data[:economic_profile] = flp.data_set
        end
      end
      if e_path[:title_i]
        tip = TitleIParser.new
        tip.load_info([e_path[:title_i], :title_i])
        if parsed_category_data[:economic_profile]
          parsed_category_data[:economic_profile].map do |k,v|
            [k, (v.merge!(tip.data_set[k]))]
          end.to_h
        else
          parsed_category_data[:economic_profile] = tip.data_set
        end
      end
    end

  end

  def economic_statewide_path(category)
    if category
      file_paths = {}
      if category[:median_household_income]
        file_paths[:median_household_income] = category[:median_household_income]
      end
      if category[:children_in_poverty]
        file_paths[:children_in_poverty] = category[:children_in_poverty]
      end
      if category[:free_or_reduced_price_lunch]
        file_paths[:free_or_reduced_price_lunch] = category[:free_or_reduced_price_lunch]
      end
      if category[:title_i]
        file_paths[:title_i] = category[:title_i]
      end
      file_paths
    end
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

      # parsed_category_data[:statewide].each do |k,v|
      #
      #   parsed_category_data[:statewide][k] = [v, rsp.data_set[k]]
      # end


      if parsed_category_data[:statewide]
        parsed_category_data[:statewide].map do |k,v|
          [k, (v.merge!(rsp.data_set[k]))]
        end.to_h
      else
        parsed_category_data[:statewide] = rsp.data_set
      end
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
