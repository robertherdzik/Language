#!/usr/bin/ruby

require 'roo'

class LanguageManager

	attr_accessor :sheet

	def initialize
		@sheet = Roo::Spreadsheet.open('./LanguageSet.xlsx')
    end

	def getRandomRowNumberFromAllAvailableRows
		rowNumber = Random.rand(@sheet.last_row)

		return rowNumber
	end

	def getForeignWordForIndex(index) 		
		rawWord = @sheet.cell(index, 1)

		return rawWord.downcase
	end

	def getTranslatedWordForIndex(index) 
		rawWord = @sheet.cell(index, 2)

		return rawWord.downcase
	end

end

class LanguageResutlValidator 

	attr_accessor :allAttempts
	attr_accessor :correctAttempts

	def initialize
		$allAttempts = 0
		$correctAttempts = 0
	end

	def validate(expectedWord, userInputWord) 
		if expectedWord == userInputWord 
			printSuccess
			$correctAttempts += 1
		 else
		 	printFailure(expectedWord)
		end

		$allAttempts += 1
	end

	def incorectAnswers 
		return $allAttempts - $correctAttempts
	end

	def correctAnswers 
		return $correctAttempts
	end

	def printSuccess 
		pritnTopSeparator
		puts '✅'
		printBottomSeparator
	end

	def printFailure(expectedWord)
		pritnTopSeparator
		puts '❌' + ' :' + expectedWord
		printBottomSeparator
	end

	def pritnTopSeparator
		puts ''
	end

	def printBottomSeparator 
		puts '------------------------------------------------' + '[' + correctAnswers().to_s + '/' + allAttempts().to_s + ']'
	end

end

# ------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------

manager = LanguageManager.new
resultValidator = LanguageResutlValidator.new

# train your language until you feel tired 😇
loop do 
	rowNumber = manager.getRandomRowNumberFromAllAvailableRows
	puts manager.getForeignWordForIndex(rowNumber)

	# get user input answer
	userInputWord = gets.chomp
	expectedWord = manager.getTranslatedWordForIndex(rowNumber)

	# validate answer
	resultValidator.validate(expectedWord, userInputWord)
  
  break if false
end 

