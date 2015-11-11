require 'csv'
require 'pry'

class EnrollmentParser

# NEW ITERATION 1 FILESET
#   ({
#  :enrollment => {
#    :kindergarten => "./data/Kindergartners in full-day program.csv",
#    :high_school_graduation => "./data/High school graduation rates.csv"
#  }
# })

  attr_accessor :csv

  def initialize(file_set)
    path = parsed_path(file_set)
    @csv = CSV.read(path, {headers: true, header_converters: :symbol}).map {|row| row.to_h}
  end

  def district_data
    final_data = grouped_data.dup
    grouped_data.each_pair do |key, value|
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

  def grouped_data
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
