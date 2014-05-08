class MoviesController < ApplicationController

  def index
    @movies = Movie.all
    @avi_movies = Movie.where(type: "avi")
    @mp4_movies = Movie.where(type: "mp4")
  end

  def show
    @movie = Movie.find params[:id]
  end

  def convert_to_mp4
    @movie = Movie.find params[:id]
    Resque.enqueue(Converter, @movie.path)
    @movie.converted = true
    @movie.save
    redirect_to movies_path, flash: {notice: "your job has been queued"}
  end

end
