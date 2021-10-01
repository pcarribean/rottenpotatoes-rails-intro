class Movie < ActiveRecord::Base
    def self.get_all_ratings_types
        return Movie.select(:rating).map(&:rating).uniq
    end
    def self.with_ratings(ratings)
        return Movie.where(rating: ratings)
    end
end
