class Book < ApplicationRecord
  has_many :recommends
  has_many :reviews
end
