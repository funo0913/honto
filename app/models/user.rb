class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :recommends
  has_many :reviews
  has_many :warning_reports

  #Validation
  validates :nickname, presence: true
  
end
