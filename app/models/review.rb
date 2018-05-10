class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book
  belongs_to :status
  has_many :warning_reports
end
