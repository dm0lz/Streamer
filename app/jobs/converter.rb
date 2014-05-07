class Converter

  @queue = :convert
  
  def self.perform path
    @conversion = FormatConverter.new(path)
    @conversion.convert_avi_to_mp4
  end

end