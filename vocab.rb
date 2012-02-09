#!/usr/bin/ruby

require 'responder'

class VocabWorker

	def initialize file, mode
		@words = []
		@used_words = []
		@mode = mode
		build_word_list file
	end

	def build_word_list file
		File.foreach(file) do |line|
			tokens = line.chomp.split
			tokens.each do |token|
				@words << token if !token.empty?
			end
		end
	end

	def pick_a_word
		if @words.size == 0
			@words = @used_words
			@used_words = []
		end

		index = rand @words.size
		word = @words[index]
		@words.delete_at index
		@used_words << word 
		word
	end
	
	def introduction
		Responder.say "What's up. I'm Harold. And this is my #{@mode}ing game."
		if @mode == :spell
			Responder.say "I'll say a word, you type in the letters that spell it and then press enter."
		else
			Responder.say "I'll print a word, you say the word and then press enter. Then I'll say the word so you know if you were right."
		end
		Responder.say "Are you ready?"
		sleep 2
		Responder.say "Let's begin."
	end

	def process
		introduction
		send("process_#{@mode}")
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

	def process_read

		while true do
			word = pick_a_word
			
			Responder.say "Say this word."
			sleep 1
			eat_bytes
			puts word

			gets
			Responder.say "The word is."
			Responder.say word 
			sleep 1
		end
	end

	def process_spell

		while true do
			first = true
			answer = nil

			while first || answer = gets.chomp do
				if first
					word = pick_a_word
					first = false
				end
			
				if answer != '' && !answer.nil?
					answer.each_char do |c|
						Responder.say c 
					end

					if word.eql? answer
						Responder.say_random	
						Responder.say_correct
						sleep 1
						break
					else
						Responder.say_incorrect	
					end
				end
			
				eat_bytes
				Responder.say "The word is."
				Responder.say word 
				sleep 1
				Responder.say "Spell."
				Responder.say word 
				
				answer = nil
			end
		end
	end
end

if __FILE__ == $0
	argc = ARGV.size
	file = ARGV.shift
	mode = ARGV.shift

	if argc != 2 || !["read", "spell"].include?(mode)
		puts "Usage: #{$0} <word-file> <mode: spell|read>"
		exit
	end
	vocab_worker = VocabWorker.new file, mode.to_sym
	vocab_worker.process
end
