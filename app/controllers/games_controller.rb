require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def home

  end

  def new
    # 1. Display a random array of 10 letters
    # with the alphabet (26 letters total)
    # (To be displayed in the card in new.html.erb)
    @letters = (0..10).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    #2. J'ai besoin d'une variable dynamique "letter"
    @letters = params[:letters]
    # Et AUSSI d'un variable dynamique "suggestion"
    @suggestion = params[:answer]

    if included?(@suggestion.upcase, @letters)
      if english_word?(@suggestion)
        @result = "Well Done !"
      else
        @result = "Not an English Word"
      end
    else
      @result = "Word does not match grid content"
    end
  end

  def included?(suggestion, letters)
    suggestion.chars.all? do |letter|
      suggestion.count(letter) <= letters.count(letter)
    end
  end

  def english_word?(suggestion)
    response = open("https://wagon-dictionary.herokuapp.com/#{suggestion}")
    json = JSON.parse(response.read)
    json['found']
  end

end
