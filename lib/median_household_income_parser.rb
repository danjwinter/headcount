require 'csv'
require 'pry'

class MedianHouseholdIncomeParser

  attr_accessor :csv, :econ_prof_key
  attr_reader :data_set

  def initialize
    @data_set = {}
  end

  # ["fuidjkhdif", :median_household_income]

  def load_info(path_econ_prof)
    @csv = CSV.read(path_econ_prof[0], {headers: true, header_converters: :symbol}).map {|row| row.to_h}
    @econ_prof_key = path_econ_prof[1]
    data_set_up
    district_data
  end

  def data_set_up
    grouped_data_by_district_name.each_pair do |key, value|
      data_set[key.upcase] = {econ_prof_key => {}}
    end
  end

  def district_data
    grouped_data_by_district_name.each_pair do |key, value|
      district_data_value(value, key)
    end
  end

  def district_data_value(value, key)
    value.each do |line|
      dates = line[:timeframe].split("-").map! {|date| date.to_i}
      hash = {dates => line_of_data(line)}
      data_set[key.upcase][econ_prof_key].merge!(hash)
    end
  end

  def line_of_data(line)
    line[:data].to_i
  end

  def grouped_data_by_district_name
    @csv.group_by do |row|
      row[:location]
    end
  end

end