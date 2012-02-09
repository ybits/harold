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

	def initialize max, mode
		@max = max
		@algebra = true if mode == :algebra
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

	def say_problem op_a, op_b, operator, result 	
		if @algebra
			tokens = ['x']
			token = tokens[rand(tokens.size)]
			op_b = token
		end
	
		printf("%s", op_a.to_s)
		STDOUT.flush
		Responder.say op_a	

		printf(" %s ", operator.symbol)
		STDOUT.flush
		Responder.say operator
 
		printf("%s", op_b.to_s)
		STDOUT.flush
		Responder.say op_b
	
		printf(" = ")
		STDOUT.flush
		Responder.say "equals"

		if @algebra
			printf("%s\n", result.to_s)
			STDOUT.flush
			Responder.say result

			Responder.say "Therefore,"
			printf("%s", op_b.to_s)
			STDOUT.flush
			Responder.say op_b
		
			printf(" = ")
			STDOUT.flush
			Responder.say "equals"
		end
	end

	def process
		
		introduction

		last_op_a = nil
		while true do
			first = true
			answer = nil

			while first || answer = gets.chomp do
				if first
					operator = pick_an_operator

					op_a = nil
					begin
						op_a = pick_a_number @max
					end while op_a == last_op_a && @max != 0
					last_op_a = op_a

					op_max = operator.symbol == "-" ? op_a : @max
					op_b = pick_a_number op_max

					result = eval "#{op_a} #{operator.symbol} #{op_b}"
					first = false
				end

				result_to_check = @algebra ? op_b : result
	
				eat_bytes
				Responder.say answer 
				if answer != '' && !answer.nil?
					answer = answer.to_i
					if answer == result_to_check
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
				
				say_problem op_a, op_b, operator, result
				answer = nil
			end
		end
	end
end

if __FILE__ == $0
	argc = ARGV.size
	max = ARGV.shift
	mode = ARGV.shift

	if argc != 2 || !["basic","algebra"].include?(mode)
		puts "Usage: #{$0} <max-number-to-use> <mode: basic|algebra>"
		exit
	end

	math_worker = MathWorker.new max.to_i, mode.to_sym
	math_worker.process
end
