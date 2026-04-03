require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ("A".."Z").to_a.sample }
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split(" ")

    if !valid_grid?(@word, @letters)
      @result = "Sorry, your word can't be built from the grid."
    elsif !english_word?(@word)
      @result = "Sorry, #{ @word } is not an English word."
    else
      @result = "Well done! #{ @word } is a valid English word."
    end
  end

  private

  def valid_grid?(word, letters)
    word.upcase.chars.all? do |letter|
      word.upcase.count(letter) <= letters.count(letter)
    end
  end

  def english_word?(word)
    url = "https://dictionary.lewagon.com/#{word}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json["found"]
  end
end
