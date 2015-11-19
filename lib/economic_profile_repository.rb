# require_relative 'kindergarten_enrollment_parser'
require_relative 'enrollment'
require_relative 'parser_repository'
require_relative 'district_repository'
require_relative 'economic_profile'
require 'pry'

class EconomicProfileRepository
    attr_accessor :ep_records, :district_repository

  def initialize
    @ep_records = {}
  end

  def load_economic_info(district_and_economic_opts)
    district_and_economic_opts.each do |k, v|
      v.merge!({name: k})
    end

    district_and_economic_opts.each do |k, name_data|
      if ep_records[name_data[:name]].nil?
        ep_records[name_data[:name]] = EconomicProfile.new(name_data)
      end
      # ep_records[name].load_new_data(data)
    end
  end

  # def load_statewide_data(file_set)
  #   parsed_statewide_data(file_set).each do |category_data|
  #     load_statewide(category_data)
  #   end
  # end

  # def load_statewide(category_data)
  #   binding.pry
  #   category_data.each do |grade|
  #     grade.each_pair do |statewide, attribute|
  #       if st_records[statewide].nil?
  #         st_records[statewide] = StatewideTest.new(statewide)
  #       end
  #       st_records[statewide].load_new_data(attribute)
  #     end
  #   end
  # end

  def parsed_economic_data(file_set)
    parser = ParserRepository.new(file_set)
    parser.parsed[:economic_profile]
  end

  def find_by_name(name)
    name.upcase!
    @ep_records.key?(name) ? @ep_records.fetch(name) : nil
  end

  def load_data(file_set)
    parsed_economic_data(file_set).each do |name, data|
      ep_records[name] ||= EconomicProfile.new(data)
    end
  end

  # def create_statewide(category_data, file_set)
  #   category_data.each do |statewide_name, attributes|
  #     st_records[statewide_name.upcase] ||= StatewideTest.new(statewide_name)
  #     st_records[statewide_name.upcase].load_new_data(attributes)
  #   end
  # end

end
