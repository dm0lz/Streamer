class FormatConverter

  def initialize input
    @input = input
    @output = input.sub(Rails.configuration.movies_path + 'avi/', Rails.configuration.streamable_movies_path + 'mp4/').sub(".avi", ".mp4")
    #@output = input.sub("/Users/molz/Desktop/films/avi/","/Users/molz/Desktop/Streamer/public/movies/mp4/").sub(".avi", ".mp4")
  end

  def convert_avi_to_mp4
    cmd = "ffmpeg -i '#{@input}' -vcodec libx264 -crf 23 -movflags faststart -preset ultrafast '#{@output}'"
    %x(#{cmd})
  end

end