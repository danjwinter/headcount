require 'csv'

class HighSchoolEnrollmentParser

  attr_accessor :csv

  def initialize(path)
    @csv = CSV.read(path, {headers: true, header_converters: :symbol}).map {|row| row.to_h}
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
    districts_data_collection[:name] = value[0].fetch(:location).upcase
    districts_data_collection[:high_school_graduation] = high_school_graduation_prep(value)
    final_data[key] = districts_data_collection
  end

  def high_school_graduation_prep(attributes)
    high_grad = {}
    attributes.each do |attribute|
      high_grad[attribute.fetch(:timeframe).to_i] = attribute.fetch(:data).to_f
    end
    high_grad
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
