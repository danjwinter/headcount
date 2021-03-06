require_relative 'kindergarten_enrollment_parser'
require_relative 'enrollment'
require_relative 'parser_repository'
require_relative 'district_repository'
require_relative 'statewide_test'
require 'pry'

class StatewideTestRepository
  attr_accessor :st_records, :district_repository

  def initialize
    @st_records = {}
  end

  def load_statewide_info(district_and_statewide_opts)
    district_and_statewide_opts.each do |name, data|
      create_new_state(name)
      st_records[name].load_new_data(data)
    end
  end

  def create_new_state(name)
    if st_records[name].nil?
      st_records[name] = StatewideTest.new(name)
    end
  end

  def load_statewide_data(file_set)
    parsed_statewide_data(file_set).each do |category_data|
      load_statewide(category_data)
    end
  end

  def load_statewide(category_data)
    category_data.each do |grade|
      grade.each_pair do |statewide, attribute|
        create_new_state(statewide)
        st_records[statewide].load_new_data(attribute)
      end
    end
  end

  def parsed_statewide_data(file_set)
    parser = ParserRepository.new(file_set)
    parser.parsed[:statewide]
  end

  def find_by_name(name)
    name.upcase!
    @st_records.key?(name) ? @st_records.fetch(name) : nil
  end

  def load_data(file_set)
    parsed_statewide_data(file_set).each do |name, data|
      st_records[name] ||= StatewideTest.new(name)
      st_records[name].load_new_data(data)
    end
  end

  def create_statewide(category_data, file_set)
    category_data.each do |statewide_name, attributes|
      st_records[statewide_name.upcase] ||= StatewideTest.new(statewide_name)
      st_records[statewide_name.upcase].load_new_data(attributes)
    end
  end
end
