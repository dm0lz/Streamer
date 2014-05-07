class FormatConverter

  def initialize input
    @input = input
    @output = input.gsub("avi", "mp4")
  end

  def convert_avi_to_mp4
    cmd = "ffmpeg -i '#{@input}' -vcodec libx264 -crf 23 -movflags faststart -preset ultrafast '#{@output}'"
    %x(#{cmd})
  end

end