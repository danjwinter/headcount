require 'csv'

class KindergartenEnrollmentParser

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
    districts_data_collection[:name] = value[0].fetch(:location)
    districts_data_collection[:kindergarten_participation] = kindergarten_participation_prep(value)
    final_data[key] = districts_data_collection
  end

  def kindergarten_participation_prep(attributes)
    kind_par = {}
    attributes.each do |attribute|
      kind_par[attribute.fetch(:timeframe).to_i] = attribute.fetch(:data).to_f
    end
    kind_par
  end

  def parsed_path(file_set)
    file_set.fetch(:enrollment).fetch(:kindergarten)
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
