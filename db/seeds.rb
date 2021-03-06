# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

unless User.exists?(:email => "test1@riskmethods.net")
  User.create!(email: "test1@riskmethods.net", password: "password")
  User.last.generate_api_key
end

unless User.exists?(:email => "test2@riskmethods.net")
  User.create!(email: "test2@riskmethods.net", password: "password")
  User.last.generate_api_key
end

User.all.each do |user|
  user.generate_api_key if user.api_key.nil?
end

15.times.each do |i|
  unless Movie.exists?(:title => "Movie #{i}")
    Movie.create!(title: "Movie #{i}", text: "Text Movie #{i}", user: User.first)
  end
end

(16..20).each do |i|
  unless Movie.exists?(:title => "Movie #{i}")
    Movie.create!(title: "Movie #{i}", text: "Text Movie #{i}", user: User.last)
  end
end

["Drama", "Sci-Fi", "Love", "Adventure", "Romance", "Family", "Musical", "Horror", "Thriller"].each do |name|
  unless Category.exists?(name: name)
    Category.create!(name: name)
  end
end

unless Movie.first.categories.any?
  Category.limit(3).each do |category|
    Movie.first.categories << category
  end

end

unless Movie.last.categories.any?
  Movie.last.categories << Category.last
end

Rating.create!(user: User.last, movie: Movie.first) unless Rating.exists?(user: User.last, movie: Movie.first)
Rating.create!(user: User.first, movie: Movie.last) unless Rating.exists?(user: User.first, movie: Movie.last)
