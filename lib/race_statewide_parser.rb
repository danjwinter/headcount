require 'csv'
require 'pry'

class RaceStatewideParser

  attr_accessor :csv
  attr_reader :data_set, :subject

  def initialize
    @data_set = {}
  end

  def load_info(path_subject)
    @csv = CSV.read(path_subject[0], {headers: true, header_converters: :symbol}).map {|row| row.to_h}
    @subject = path_subject[1]
    build_data_set
  end

  def build_data_set
    data_set_key_setup
    final_data = grouped_data_by_district_name.dup
    grouped_data_by_district_name.each_pair do |key, value|
      district_data_value(key, value, final_data)
    end
    final_data
  end

  def data_set_key_setup
    if data_set.keys.empty?
      set_up_data_hash
    end
  end

  def set_up_data_hash
    districts = grouped_data_by_district_name.keys.each {|district| district.upcase}
    races = []; dates = []
    collect_races_and_dates(races, dates)
    configure_hash(districts, races, dates)
  end

  def configure_hash(districts, races, dates)
    districts.each do |district|
      @data_set[district.upcase] = race_setup(races.uniq, dates.uniq)
    end
  end

  def collect_races_and_dates(races, dates)
    grouped_data_by_district_name.each do |key, value|
      value.each do |line|
        races << symbolize_spaced(line[:race_ethnicity])
        dates << line[:timeframe].to_i
      end
    end
  end

  def symbolize_spaced(word)
    if word.upcase == "HAWAIIAN/PACIFIC ISLANDER"
      :pacific_islander
    elsif word.include?(" ")
      word.downcase.split.join("_").to_sym
    else
      word.downcase.to_sym
    end
  end

  def race_setup(races, dates)
    races.map {|race| [race, date_setup(dates)]}.to_h
  end

  def date_setup(dates)
    dates.map {|date| [date.to_i, {math: nil, reading: nil, writing: nil}]}.to_h
  end

  def district_data_value(key, value, final_data)
    value.each do |line|
      district = key.upcase; race = symbolize_spaced(line[:race_ethnicity])
      year = line[:timeframe].to_i; score = line[:data].to_f
      self.data_set[district][race][year][@subject] = score
    end
  end

  def grouped_data_by_district_name
    @csv.group_by do |row|
      row[:location]
    end
  end

end
