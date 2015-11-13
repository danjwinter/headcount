require_relative './enrollment'
require_relative './statewide_test'

class District
  attr_reader :name, :enrollment

  def initialize(data, enrollment)
    @name = data.fetch(:name).upcase
    @enrollment ||= enrollment
  end
end
