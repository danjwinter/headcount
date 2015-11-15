require 'csv'
require 'pry'

class RaceStatewideParser

  attr_accessor :csv
  attr_reader :data_set

  def initialize
    @data_set = {}
    # @csv = CSV.read(path_race[0], {headers: true, header_converters: :symbol}).map {|row| row.to_h}
    # @race = path_race[1]
  end

  def load_info(path_subject)
    @csv = CSV.read(path_subject[0], {headers: true, header_converters: :symbol}).map {|row| row.to_h}
    @subject = path_subject[1]

  end

  # def proficient_by_race_or_ethnicity(race)





  #
  # end


  def set_up_data_hash
    final_data = grouped_data_by_district_name.dup
    districts = final_data.keys
    races = []
    dates = []
    race_dates = final_data.map do |key, value|
      value.each do |line|
        races << line[:race_ethnicity]
        dates << line[:timeframe]
      end
    end

    districts.each do |district|
      @data_set[district.upcase] = race_setup(races.uniq, dates.uniq)
    end
  end


  def race_setup(races, dates)
    race_opts = {}
    races.each do |race|
      race_opts[race] = date_setup(dates)
    end
    race_opts
  end

  def date_setup(dates)
    date_opts = {}
    dates.each do |date|
      date_opts[date.to_i] = {math: nil, reading: nil, writing: nil}
    end
    date_opts
  end

  def district_data
    # binding.pry
    if self.data_set.keys.empty?
      set_up_data_hash
    end
    final_data = grouped_data_by_district_name.dup
    grouped_data_by_district_name.each_pair do |key, value|

      district_data_value(key, value, final_data)
    end
    final_data
  end



  def district_data_value(key, value, final_data)
    value.each do |line|
      district = key.upcase
      race = line[:race_ethnicity]
      year = line[:timeframe].to_i
      @subject
      score = line[:data].to_f
      self.data_set[district][race][year][@subject] = score
    end

    districts_data_collection = {}
    year_data = {}
    districts_data_collection[:name] = key.upcase
    districts_data_collection[@race] = year_prep(value, year_data)
    final_data[key] = districts_data_collection
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
      race = attribute[:race_ethnicity].downcase.to_sym
      score = attribute[:data].to_f
      year_data[attribute[:timeframe].to_i].merge!({race => score})
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
