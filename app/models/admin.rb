class Admin < ApplicationRecord
  after_validation :remove_unnecessary_error_messages
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :email, presence: true ,uniqueness: true
  validates :password, confirmation: true
  validates :password_confirmation , presence: true

  # password_confirmationのエラーメッセージが重複するので削除
  def remove_unnecessary_error_messages
    errors.messages[:password_confirmation].uniq!
  end

end
