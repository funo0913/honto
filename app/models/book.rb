class Book < ApplicationRecord
  has_many :recommends
  has_many :reviews

  attr_accessor :search_word
  attr_accessor :thumbnail

  paginates_per 10

  def self.hash_inititalize(hash)
    book = Book.new(
      isbn: hash[:isbn],
      title:  hash[:title],
      author:  hash[:author],
      publication:  hash[:publication],
      publisher:  hash[:publisher],
      tmp_id:  hash[:tmp_id],
      description:  hash[:description]
    )
  end
end
