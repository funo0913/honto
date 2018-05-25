# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  after_action :delete_after_sign_in_message, only: [:destroy]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def after_sign_in_path_for(resource)
    reviews_path
  end

  #ログアウト後に表示するメッセージを削除
  def delete_after_sign_in_message
    if flash[:notice].present?
      flash.delete(:notice)
    end
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
