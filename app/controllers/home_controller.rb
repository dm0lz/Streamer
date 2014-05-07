class HomeController < ApplicationController
  def index
    #@movies = Dir.glob("public/movies/**.mp4").map{|l| l.sub("public/", "")}
    @movies = Movie.all
    #binding.pry
  end
  def show
    #binding.pry
  end
end
