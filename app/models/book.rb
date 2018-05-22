class Book < ApplicationRecord
  has_many :recommends
  has_many :reviews

  attr_accessor :search_word
  attr_accessor :thumbnail
  
  paginates_per 10
end
