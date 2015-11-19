require 'csv'
require 'pry'

class GradeStatewideParser

  attr_accessor :csv, :grade
  attr_reader :data_set

  def initialize
    @data_set = {}
  end

  def load_info(path_grade)
    @csv = CSV.read(path_grade[0], {headers: true, header_converters: :symbol}).map {|row| row.to_h}
    @grade = path_grade[1]
    district_data
  end

  def district_data
    final_data = grouped_data_by_district_name.dup
    grouped_data_by_district_name.each_pair do |key, value|
      district_data_value(key.upcase, value, final_data)
    end
  end

  def district_data_value(key, value, final_data)

    districts_data_collection = {}
    year_data = {}
    districts_data_collection[@grade] = year_prep(value, year_data)
    if data_set[key]
      data_set[key].merge!(districts_data_collection)
    else
      data_set[key] = districts_data_collection
    end
  end

  def year_prep(attributes, year_data)
    attributes.map do |attribute|

      attribute[:timeframe].to_i
    end.uniq.each do |year|
      year_data[year] = {}
    end
    set_subject_and_score(year_data, attributes)
  end

  def set_subject_and_score(year_data, attributes)
    attributes.each do |attribute|
      subject = attribute[:score].downcase.to_sym

      num_test = attribute[:data] =~ /\d/
      if  num_test.is_a? Numeric
        score = attribute[:data].to_f
      else
        score = "N/A"
      end
      year_data[attribute[:timeframe].to_i].merge!({subject => score})
    end
    year_data
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
