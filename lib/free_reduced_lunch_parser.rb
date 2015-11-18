require 'csv'
require 'pry'

class FreeReducedLunchParser

  attr_accessor :csv, :econ_prof_key
  attr_reader :data_set

  def initialize
    @data_set = {}
  end

  def load_info(path_econ_prof)
    @csv = CSV.read(path_econ_prof[0], {headers: true, header_converters: :symbol}).map {|row| row.to_h}
    @econ_prof_key = path_econ_prof[1]
    data_set_up
    district_data

  end

  def data_set_up
    grouped_data_by_district_name.each_pair do |key, value|
      data_set[key.upcase] = {econ_prof_key => year_set_up(value)}
    end
  end

  def year_set_up(value)
    years = value.map {|line| line[:timeframe]}.uniq
    years.map {|year| [year.to_i, {}]}.to_h

  end

  def district_data
    final_data = grouped_data_by_district_name.dup
    grouped_data_by_district_name.each_pair do |key, value|

      district_data_value(key.upcase, value)
    end
  end

  def district_data_value(key, value)
    selected = value.select do |attribute|
      attribute[:poverty_level] == "Eligible for Free or Reduced Lunch"
    end
    selected.each do |line|
      if line[:dataformat] == "Percent"
        data_set[key][econ_prof_key][line[:timeframe].to_i].merge!({percentage: line[:data].to_f})
      else
        data_set[key][econ_prof_key][line[:timeframe].to_i].merge!({total: line[:data].to_i})
      end
    end
  end

  def year_prep(attributes)
    sorted_selected = selected.sort_by do |line|
      line[:dataformat]
    end
    sorted_selected.each do |line|
        line[:timeframe] = {}
      end
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