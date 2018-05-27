class Admins::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_admin_user, only: [:show,:edit,:update,:destroy]
  layout 'admin_application'
  # GET /admins/users
  # GET /admins/users.json
  def index
    @admins_users = User.all
  end

  # GET /admins/users/1
  # GET /admins/users/1.json
  def show
  end

  # GET /admins/users/1/edit
  def edit
  end

  # PATCH/PUT /admins/users/1
  # PATCH/PUT /admins/users/1.json
  def update
    if @admins_user.update(admins_user_params)
      redirect_to admins_user_path(@admins_user.id)
    else
      render :edit
    end
  end

  # DELETE /admins/users/1
  # DELETE /admins/users/1.json
  def destroy
    @admins_user.destroy
    redirect_to admins_users_path
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def admins_user_params
      params.require(:user).permit(:nickname,:email)
    end

    def set_admin_user
      @admins_user = User.find(params[:id])
    end
end
