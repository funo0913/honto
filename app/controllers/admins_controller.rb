class AdminsController < ApplicationController
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
  def destroy
    admin = Admin.find(params[:id])
    admin.delete
  end
  def create
    admin = Admin.new(admins_admin_params)
    admin.save
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def admins_admin_params
      params.require(:admin).permit(:email,:password)
    end
end
