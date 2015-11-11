require_relative './enrollment'

class District
  attr_accessor :data
  attr_reader :name, :enrollment

  def initialize(data, enrollment)
    @data = data
    @name = data.fetch(:name).upcase
    @enrollment = enrollment
  end

end
