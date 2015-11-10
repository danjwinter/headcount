require_relative './enrollment'

class District
  attr_accessor :data
  attr_reader :name, :enrollment

  def initialize(data)
    @data = data
    @name = data.fetch(:name).upcase
    @enrollment = Enrollment.new(data)
  end

end
