class WarningReportController < ApplicationController
  before_action :authenticate_user!, only:[:create]
  before_action :authenticate_admin!, only: [:index,:edit,:update,:destroy]
  layout 'admin_application'

  def index
    @warning_reports = WarningReport.all
  end

  def create
    warning = WarningReport.new
    warning.review_id = params[:id]
    warning.user_id = current_user.id
    warning.save
    redirect_to review_path(params[:id]), notice: '通報しました'
  end

  def show
    @warning_report = WarningReport.find(params[:id])
    @summary = WarningReport.where(review_id: @warning_report.review_id).count
    @review = Review.find(@warning_report.review_id)
  end

  def update
    warning_report = WarningReport.find(params[:id])
    # 感想のwarningフラグを立てる
    review = Review.find(warning_report.review_id)
    review.warning = true
    review.save
    # 同じ感想に対する通報は一括で対応済みとする
    warning_reports = WarningReport.where(:review_id => params[:id]).update_all(:dealt => true)

    redirect_to warning_report_index_path
  end

end
