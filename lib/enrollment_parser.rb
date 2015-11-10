require 'csv'
require 'pry'

class EnrollmentParser

  attr_accessor :csv

  def initialize(path)
    @csv = CSV.read(path, {headers: true, header_converters: :symbol}).map {|row| row.to_h}
  end

  def district_data
    @csv.group_by do |row|
      row[:location]
    end

  end
  #
  # def district_data_test
  #   @csv.reduce([]) do |orig, row|
  #     {name: row["Location"]} unless orig.include?
  #   end.uniq
  # end

  # def enrollment_data
  #   @csv.map do |row|
  #     {name: row["Location"],kindergarten_participation: {row["TimeFrame"]: row["Data"]} }
  #   end.uniq
  # end

end

# dr = DistrictRepository.new
# dr.load_data(:kindergarten => "./data/Kindergartners in full-day program.csv")
# district = dr.find_by_name("ACADEMY 20")
