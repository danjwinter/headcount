class ParserRepository
  attr_reader :enrollment

  def initialize(file_set)
    @enrollment = file_set.fetch(:enrollment)
  end

  # def parsed_path(file_set)
  #   file_set.fetch(:enrollment).fetch(:kindergarten)
  # end


end
