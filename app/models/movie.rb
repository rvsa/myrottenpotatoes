class Movie < ActiveRecord::Base
  def self.getRatings()
#    Movie.select("DISTINCT rating")
    Movie.select(:rating).map(&:rating).uniq
  end
end
