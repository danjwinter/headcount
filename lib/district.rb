require_relative './enrollment'
require_relative './statewide_test'

class District
  attr_reader :name, :enrollment, :statewide

  def initialize(name_and_attribute_opts)
    @name = name_and_attribute_opts[:name]
    @enrollment ||= name_and_attribute_opts[:enrollment]
    @statewide ||= name_and_attribute_opts[:statewide]
  end
end
