namespace :movies do

  desc "Update Movies Lists"
  
  task update: :environment do
    MovieParser.update_movies
  end

end
