class Admins::AdminsController < ApplicationController
  before_action :authenticate_admin!
  layout 'admin_application'
  def top
    #ログイン後の表示画面
    @warning_reports_count = WarningReport.where(dealt: false).count
  end
  def index
    @admins = Admin.all
  end
  def new
    @admin = Admin.new
  end
  def create
    @admin = Admin.new(admins_admin_params)

    if @admin.save
      flash[:notice] = '管理ユーザを追加しました'
      redirect_to action: 'index'
    else
      flash[:alert] = @admin.errors.full_messages
      render 'admins/admins/new'
    end
  end
  def edit
    @admin = Admin.find(params[:id])
  end
  def update
    admin = Admin.find(params[:id])
    if admin.update(admins_admin_params)
      flash[:notice] = '管理ユーザーを更新しました'
      redirect_to action: 'index'
    else
      flash[:alert] = 'エラーが発生しました'
    end
  end
  def destroy
    admin = Admin.find(params[:id])
    admin.destroy
    flash[:notice] = '管理ユーザを削除しました'
    redirect_to action: 'index'
  end
  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def admins_admin_params
      params.require(:admin).permit(:email,:password,:password_confirmation)
    end
end
