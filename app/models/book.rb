class Book < ApplicationRecord
  has_many :recommends
  has_many :reviews

  attr_accessor :search_word
  attr_accessor :thumbnail
  attr_accessor :tmp_id
  paginates_per 10
end
