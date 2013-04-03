# thanks to carrierwave wiki!

class CustomStringIO < StringIO
  attr_accessor :original_filename

  def initialize(*args)
    super(*args[1..-1])
    @original_filename = File.basename(args[0])
  end
end