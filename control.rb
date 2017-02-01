require './validator.rb'

class Control

	def run
		Validator.new.validate
	end

end

Control.new.run
