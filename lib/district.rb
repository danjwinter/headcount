require_relative './enrollment'
require_relative './statewide_test'

class District
  attr_reader :name, :enrollment, :statewide_test, :economic

  def initialize(name_and_attribute_opts)
    @name = name_and_attribute_opts[:name]
    @enrollment ||= name_and_attribute_opts[:enrollment]
    @statewide ||= name_and_attribute_opts[:statewide]
    @economic ||= name_and_attribute_opts[:economic]
  end

  def load_info(attribute_opts)
    @enrollment ||= attribute_opts[:enrollment]
    @statewide_test ||= attribute_opts[:statewide]
    @economic||= attribute_opts[:economic]
  end
end
