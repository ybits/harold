class Responder
	
	RESPONSES = [
		"Great job",
		"Good answer!",
		"You are doing so well!",
		"Get this kid a diploma",
		"Smart kid",
		"Very good",
		"You are smart enough to build a rocket ship and fly to the moon",
		"Wow Wow Wow.",
		"You float like a beautiful butterfly",
		"You can swim like a starfish in the deep blue sea",
		"Incredible",
		"I believe we have a genius in the house",
		"I bet you have some great dreams, since you're so darn clever",
		"I have never seen such a smart fella",
		"Pee pee and the pee pee. There. I said it.",
		"You must be sitting on a toadstool",
		"Whatever you eat, keep eating it",
		"I need to find some tougher questions",
		"Holy moly, you are pretty good at this",
		"It's going to be an easy Saturday when you take your S A tees",
		"You know, I'm glad I know someone as bright as you.",
		"Excellent work.",
		"Jumping junebugs!",
		"Yep.",
		"Right on."
	]

	def self.eat_bytes
		begin
			while c = STDIN.read_nonblock(1000)
				##
			end
		rescue Errno::EAGAIN
			##
		end
	end

	def self.say_mode
		if @mode.nil?
			@mode = :text
			`type say 2>/dev/null 1>/dev/null`
			if $?.success?
				@mode = :say
				return @mode
			end	
			`type espeak 2>/dev/null 1>/dev/null`
			if $?.success?
				@mode = :espeak
				return @mode
			end
		end
		@mode
	end

	def self.say_random
			say "#{RESPONSES[rand RESPONSES.size]}"
	end

	def self.say_correct
			say "That's correct.", true
	end

	def self.say_incorrect
			say "Sorry, that's incorrect. Try again.", true
	end

	def self.say phrase, write=false
		case say_mode
		when :text
			puts "#{phrase}" if write
		when :say
			`say "#{phrase}"`
		when :espeak
			`echo "#{phrase}" | espeak`	
		end
	end

	def self.say_all
		RESPONSES.each do |response|
			say response, true
		end
	end

end
