require_relative './enrollment'

class District
  attr_reader :name, :enrollment

  def initialize(data, enrollment)
    @name = data.fetch(:name).upcase
    @enrollment = enrollment
  end

end
