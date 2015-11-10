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
      districts[district_name.upcase] = District.new(districts_data(attributes) )
     end
  end

  def districts_data(attributes)
    districts_data_collection = {}
    #generates {:name => "ACADEMY 20"}
    districts_data_collection[:name] = attributes[0].fetch(:location)
    districts_data_collection[:kindergarten_participation] = kindergarten_participation_prep(attributes)
    districts_data_collection
  end

  def kindergarten_participation_prep(attributes)
    kind_par = {}
    attributes.each do |attribute|
      kind_par[attribute.fetch(:timeframe).to_i] = attribute.fetch(:data).to_f
    end
    kind_par

  end

  def parsed_district_data(file_set)
    EnrollmentParser.new(path(file_set)).district_data
  end

  def path(file_set)
    file_set.fetch(:enrollment).fetch(:kindergarten)
  end

  def find_by_name(name)
    @districts.key?(name.upcase) ? @districts.fetch(name.upcase) : nil
  end

  def find_all_matching(frag)
    @districts.values.find_all do |district|
      district.name.include?(frag.upcase)
    end
  end
end
