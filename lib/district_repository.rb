require_relative 'enrollment_parser'
require_relative 'district'
require 'pry'

class DistrictRepository
  attr_accessor :districts

  def initialize
    @districts = []
  end

  def path(file_set)
    file_set.fetch(:kindergarten)
  end

  def load_data(file_set)
    parsed_district_data(file_set).each do |district|
       @districts << District.new(district)
     end
  end

  def parsed_district_data(file_set)
    EnrollmentParser.new(path(file_set)).district_data
  end

  def find_by_name(name)
    @districts.find do |district|
      # binding.pry
      district.name == name.upcase
    end
  end
end


# [{:name=>"Colorado"},
# {:name=>"ACADEMY 20"}]

# dr = DistrictRepository.new
# dr.load_data(:kindergarten => "./data/Kindergartners in full-day program.csv")
# district = dr.find_by_name("ACADEMY 20")
