module MovieParser

  MOVIES_PATH = Rails.configuration.movies_path
  STREAMABLE_MOVIES_PATH = Rails.configuration.streamable_movies_path

  def self.update_movies
    @avi_movies = %x(ls #{MOVIES_PATH + "avi/**.avi"}).gsub("\n", "").split(".avi").map{|l| l.concat(".avi")}
    @avi_movies.each{|l| Movie.where(title: l.sub("#{MOVIES_PATH + 'avi/'}", ""), path: l, type: "avi").first_or_create}
    puts "#{@avi_movies.count} avi movies updated" 

    @mp4_movies = %x(ls #{STREAMABLE_MOVIES_PATH + "mp4/**.mp4"}).gsub("\n", "").split(".mp4").map{|l| l.concat(".mp4")}
    @mp4_movies.each{|l| Movie.where(title: l.sub("#{STREAMABLE_MOVIES_PATH + 'mp4/'}", ""), path: l, type: "mp4").first_or_create}
    puts "#{@mp4_movies.count} mp4 movies updated"
  end

end