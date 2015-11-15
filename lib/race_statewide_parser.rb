require 'csv'
require 'pry'

class RaceStatewideParser

  attr_accessor :csv

  def initialize(path_race)
    @csv = CSV.read(path_race[0], {headers: true, header_converters: :symbol}).map {|row| row.to_h}
    @race = path_race[1]
  end

  def district_data
    final_data = grouped_data_by_district_name.dup
    grouped_data_by_district_name.each_pair do |key, value|
      district_data_value(key, value, final_data)
    end
    final_data
  end

  def district_data_value(key, value, final_data)
    districts_data_collection = {}

    districts_data_collection[:name] = key.upcase
    districts_data_collection[:race_ethnicity] = year_prep(value)
    final_data[key] = districts_data_collection
  end

  def year_prep(attributes)
    math_data = {}
    attributes.each do |attribute|
      binding.pry
      math_data[attribute.fetch(:timeframe).to_i] = subject_prep(attribute)
    end
    math_data
  end

  def subject_prep(attribute)
    subject_data = {}
    subject_data[attribute.fetch()]
  end

  def grouped_data_by_district_name
    @csv.group_by do |row|
      row[:location]
    end
  end

  def enrollment_data
    @csv.group_by do |row|
      row[:location]
    end
  end
end
