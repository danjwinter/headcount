require 'csv'
require 'pry'

class Parser

  attr_accessor :csv

  def initialize(path)
    binding.pry
    @csv = CSV.read(path, {headers: true, return_headers:false})
  end

  def district_data
    @csv.map do |row|
      {name: row["Location"]}
    end.uniq
  end

end

# dr = DistrictRepository.new
# dr.load_data(:kindergarten => "./data/Kindergartners in full-day program.csv")
# district = dr.find_by_name("ACADEMY 20")
