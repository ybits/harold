#!/usr/bin/ruby

require 'responder'

class Operator
	def initialize operator
		@operator = operator
	end

	def to_s
		case @operator
		when "+"
			return "plus"
		when "-"
			return "minus"
		end
	end

	def symbol
		@operator
	end
end

class MathWorker

	def initialize max
		@max = max
	end
	
	def pick_a_number max
		rand max + 1	
	end

	def pick_an_operator
		operators = ["+", "-"]
		Operator.new operators[rand operators.size]
	end

	def introduction
		Responder.say "How's it going? My name is Harold. And this is my math game."
		Responder.say "I'll give you a problem, you type the answer and then press enter."
		Responder.say "Are you ready?"
		sleep 2
		Responder.say "Let's begin."
	end

	def eat_bytes
		begin
			while c = STDIN.read_nonblock(1000)
				##
			end
		rescue Errno::EAGAIN
			##
		end
	end

	def process
		
		introduction

		while true do
			first = true
			answer = nil

			while first || answer = gets.chomp do
				if first
					operator = pick_an_operator

					op_a = pick_a_number @max

					op_max = operator.symbol == "-" ? op_a : @max
					op_b = pick_a_number op_max

					result = eval "#{op_a} #{operator.symbol} #{op_b}"
					first = false
				end
			
				eat_bytes
				Responder.say answer 
				if answer != '' && !answer.nil?
					answer = answer.to_i
					if answer == result
						if (rand 1) == 0
							Responder.say_random	
						end
						 Responder.say_correct
						sleep 1
						break
					else
						Responder.say_incorrect	
					end
				end
			
				printf("%d", op_a)
				STDOUT.flush
				Responder.say op_a	

				printf(" %s ", operator.symbol)
				STDOUT.flush
				Responder.say operator
		 
				printf("%d", op_b)
				STDOUT.flush
				Responder.say op_b
			
				printf(" = ")
				STDOUT.flush
				Responder.say "equals"		

				answer = nil
			end
		end
	end
end

if __FILE__ == $0
	if ARGV.size != 1
		puts "Usage: #{$0} <max-number-to-use>"
		exit
	end
	arg = ARGV.shift

	if arg == 'responses'
		Responder.say_all
		exit
	end

	arg = 5 if arg.nil?
	arg = arg.to_i
	
	math_worker = MathWorker.new arg
	math_worker.process
end
