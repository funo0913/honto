class UsersController < ApplicationController
  def top
    # 残っているメッセージは削除する
    if flash[:alert].present?
      flash.delete(:alert)
    end
    # LPの表示
    render layout: false
  end
  def show
    @user = User.find(current_user.id)
    @search_book = Book.new
  end
end
