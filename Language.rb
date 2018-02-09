#!/usr/bin/ruby

require 'roo'

class LanguageManager

	attr_accessor :sheet

	def initialize
		# add correct localization for you .xlsx file
		@sheet = Roo::Spreadsheet.open('./LanguageSet.xlsx')
    end

	def getRandomRowNumberFromAllAvailableRows
		rowNumber = Random.rand(@sheet.last_row)

		# try to get the `line number` that meets the validation process
		if validateValuesFromSheet(rowNumber) == false
			rowNumber = getRandomRowNumberFromAllAvailableRows
		end

		return rowNumber
	end

	# method check whether values are not `nil`
	def validateValuesFromSheet(rowNumber) 
		foreginWord = getRawValueFromSheet(rowNumber, 1) # todo: remove duplication
		translatedWord = getRawValueFromSheet(rowNumber, 2)

        validationResult = false
		if foreginWord != nil && translatedWord != nil 
			validationResult = true
		end
        
        return validationResult
	end

	def getForeignWordForRow(row) 		
		rawWord = getRawValueFromSheet(row, 1)

		return rawWord.downcase
	end

	def getTranslatedWordForRow(row) 
		rawWord = getRawValueFromSheet(row, 2)

		return rawWord.downcase
	end

	def getRawValueFromSheet(row, column) 
		return @sheet.cell(row, column)
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

			return true
		 else
		 	printFailure(expectedWord)

		 	return false
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
		puts '❌' + ' CORRECT ANSWER: ' + '>> ' + expectedWord + ' <<'
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

def setupInterfaceAccordingToValidationResult(validationResult) 
	if validationResult == true 
		sleep 1
		puts `clear`
	else 
		puts 'PRESS ANY KEY TO CONTINUE 🏁'
		gets.chomp
		puts `clear`
	end
end 

manager = LanguageManager.new
resultValidator = LanguageResutlValidator.new

# train your language until you feel tired 😇
loop do 

	rowNumber = manager.getRandomRowNumberFromAllAvailableRows
	puts manager.getForeignWordForRow(rowNumber)

	# get user input answer
	userInputWord = gets.chomp
	expectedWord = manager.getTranslatedWordForRow(rowNumber)

	# validate answer
	validationResult = resultValidator.validate(expectedWord, userInputWord)
  	setupInterfaceAccordingToValidationResult(validationResult)
	
  break if false
end 

