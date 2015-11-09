require_relative 'parser'

class DistrictRepository
  attr_accessor :districts

  def initialize
    @districts = []
  end

  def path(file_set)
    "#{file_set.values}"
  end

  def load_data(file_set)
    Parser.new(path(file_set)).district_data
  end
end


# [{:name=>"Colorado"},
# {:name=>"ACADEMY 20"}]

# dr = DistrictRepository.new
# dr.load_data(:kindergarten => "./data/Kindergartners in full-day program.csv")
# district = dr.find_by_name("ACADEMY 20")
