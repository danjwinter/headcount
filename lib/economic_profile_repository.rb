require_relative 'enrollment'
require_relative 'parser_repository'
require_relative 'district_repository'
require_relative 'economic_profile'

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
    end
  end

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
end
