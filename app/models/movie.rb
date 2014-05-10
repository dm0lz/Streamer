class Movie
  
  include Mongoid::Document
  
  field :title, type: String
  field :url, type: String
  field :duration, type: String
  field :path, type: String
  field :type, type: String
  field :converted, type: Boolean, default: false


end
