require_relative 'enrollment_parser'
require_relative 'district'
require 'pry'

class DistrictRepository
  attr_accessor :districts

  def initialize
    @districts = {}

  end

  def load_data(file_set)
    parsed_district_data(file_set).each_pair do |district_name, attributes|
      # binding.pry
      districts[district_name.upcase] = District.new(attributes)
     end
  end

  def parsed_district_data(file_set)
    # EnrollmentParser.new(path(file_set)).district_data
    EnrollmentParser.new(file_set).district_data
  end

  # def path(file_set)
  #   file_set.fetch(:enrollment).fetch(:kindergarten)
  # end

  def find_by_name(name)
    @districts.key?(name.upcase) ? @districts.fetch(name.upcase) : nil
  end

  def find_all_matching(frag)
    @districts.values.find_all do |district|
      district.name.include?(frag.upcase)
    end
  end
end
