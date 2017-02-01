require './ratings.rb'

class Validator

	def initialize
		@r_base = Ratings.new('u1.base')
		@r_test = Ratings.new('u1.test')
	end

	def validate
		correct = 0
		incorrect = 0
		start_time = Time.now
		#for every rating that is in the test set, run the predict algorithm and check the number of correct.
		@r_test.user_set.each do |u, m|
			m.each do |movie|
				if (@r_base.predict_rating(u, movie[0]) == movie[1].to_i)
					correct += 1
				else
					incorrect += 1
				end
			end
		end
	end_time = Time.now
		percent = (correct.to_f/incorrect.to_f) * 100
		percent = percent.round(1)
		alg_speed = end_time - start_time
		puts "Correct: #{correct}, Incorrect: #{incorrect}, Percent Correct: #{percent}%, Algorithm Speed: #{alg_speed} s"
	end

end
