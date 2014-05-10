class MoviesController < ApplicationController

  def index
    @movies = Movie.all
    @avi_movies = Movie.where(type: "avi")
    @mp4_movies = Movie.where(type: "mp4")
    #binding.pry
  end

  def show
    @movie = Movie.find params[:id]
  end

  def convert_to_mp4
    @movie = Movie.find params[:id]
    Resque.enqueue(Converter, @movie.path)
    @movie.converted = true
    @movie.save
    redirect_to movies_path, flash: {notice: "your job has been queued successfully"}
  end

  def progress_poll
    @mp4_movies = Movie.where(type: "mp4")
    @txts_paths = @mp4_movies.map{|l| l.path.concat('.txt')}
    @progress = {}
    @txts_paths.each do |movie|
      f = File.open(movie)
      f.seek(-58, IO::SEEK_END)
      movie_id = Movie.find_by(title: movie.sub("#{Rails.configuration.streamable_movies_path + 'mp4/'}","").sub(".mp4.txt",".avi")).id.to_s
      @progress[movie_id] = f.readline[5..15]
      avi_movie_duration = Movie.find_by(title: movie.sub("#{Rails.configuration.streamable_movies_path + 'mp4/'}","").sub(".mp4.txt",".avi")).duration
      avi_movie_duration_in_seconds = ffmpeg_time_to_second avi_movie_duration
      mp4_movie_duration_in_seconds = ffmpeg_time_to_second @progress[movie_id]
      progress_rate = (mp4_movie_duration_in_seconds * 100) / avi_movie_duration_in_seconds
      @progress[movie_id] = progress_rate
    end
    #binding.pry
    #render json: @progress.to_json
  end

  def ffmpeg_time_to_second timestamp
    hours = timestamp[0..1].to_i * 60 * 60
    minutes = timestamp[3..4].to_i * 60
    seconds = timestamp[6..7].to_i
    @duration_in_second = hours + minutes + seconds
  end

  #def get_movie_duration movie
  #  input = "/Users/molz/Desktop/films/avi/Bad Country 2014 FRENCH DVDRiP XviD-CARPEDIEM.avi"
  #  cmd = "ffmpeg -i '#{input}' 2>&1 | grep 'Duration'| cut -d ' ' -f 4 | sed s/,//"
  #  @movie_duration = %x(#{cmd}).sub("\n","")
  #end

  #tail -r Bad\ Country\ 2014\ FRENCH\ DVDRiP\ XviD-CARPEDIEM.mp4.txt | grep -m 1 '.'|cut -d' ' -f12

end
