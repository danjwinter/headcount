require_relative 'enrollment_parser'
require_relative 'district'
require 'pry'

class DistrictRepository
  attr_accessor :districts

  def initialize
    @districts = {}
  end

  def path(file_set)
    file_set.fetch(:kindergarten)
  end

  def load_data(file_set)
    parsed_district_data(file_set).each_pair do |district, attributes|
      districts[district] = District.new(district, attributes)
     end
  end

  def parsed_district_data(file_set)
    EnrollmentParser.new(path(file_set)).district_data
  end

  def find_by_name(name)
    @districts.key?(name) ? @districts.fetch(name) : nil
  end

  def find_all_matching(frag)
    @districts.values.find_all do |district|
      district.name.include?(frag.upcase)
    end
  end
end
