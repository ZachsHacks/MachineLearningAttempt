require 'byebug'
class Ratings

	attr_accessor :user_set
	attr_accessor :pred

	def initialize(filename, test_set = nil)
		load_data(filename)
	end

	#parse data from u.data
	def load_data(file)
		@user_set = Hash.new
		@sim_set = Hash.new
		@movies = Array.new
		File.open(file).each do |line|
			line = line.split(" ")
			generate_movies(line[0]) unless file.include? "test"
			generate_user_pref(line[0], line[1], line[2])
		end
		# generate_predictions unless  file.include? "test"
	end


	def generate_movies(movie_id)
		@movies.push(movie_id) unless @movies.include?(movie_id)
	end

	#generates hash of movies belonging to each user.
	def generate_user_pref(user_id, movie_id, rating)
		if (@user_set[user_id] != nil)
			#@user_set[user_id].push([movie_id, rating])
			@user_set[user_id][movie_id] = rating
		else
			@user_set[user_id] = Hash.new#Array.new.push([movie_id, rating])
			@user_set[user_id][movie_id] = rating
		end
	end

	#Calculates the similarity between to users by first seeing what they have in common.
	#Then from that, make sure that the ratings are within one from each other.
	#"sim" is the final number of movies that are in common and close enough rated.
	def similarity(user1,user2)
		sim = 0
		first_user = @user_set["#{user1}"].sort_by{|k, v| k.to_i}.to_h
		second_user = @user_set["#{user2}"].sort_by{|k, v| k.to_i}.to_h
		in_common = first_user.keys & second_user.keys
		in_common.each do |movie|
			if (first_user[movie].to_i.between?(second_user[movie].to_i-1, second_user[movie].to_i+1))
				sim += 1
			end
		end
		return sim
	end

	#performs similarity for all users that are not themself. Then returns array of top 5 users.
	def most_similar(u)
		if (!@sim_set[u].nil?)
			return @sim_set[u]
		end
		common_list = Array.new
		@user_set.keys.each do |user|
			common_list.push([similarity(u, user.to_i), user]) if (u != user && similarity(u, user.to_i) > 0)
		end
		top_ratings = common_list.to_h.keys.sort.last(5)
		sim_users = Array.new
		top_ratings.each do |key| sim_users.push(common_list.to_h[key]) end
		generate_relative_similarities(u, sim_users)
			return sim_users
		end

		def generate_relative_similarities(user, user_list)
			@sim_set[user] = user_list - [user]
			user_list.each do |u|
				@sim_set[u] = user_list - [u]
			end
		end

		#returns rating of movie in training set
		def past_rating(u, m)
			rating = @user_set[u.to_s][m.to_s]
			if (rating.nil?)
				0
			else
				rating.to_i
			end
		end

		#predicts what rating user will give to particular movie based off of history
		def predict_rating(u, m)
			if past_rating(u, m) != 0
				return past_rating(u,m)
			end
			sim_users = most_similar(u)
			rating = 0
			divisor = 0
			sim_users.each do |user|
				their_rating = past_rating(user, m)
				if (their_rating != 0)
					rating += their_rating
					divisor += 1
				end
			end
			if divisor == 0
				return 4
			end
			return rating/divisor
		end

	end
