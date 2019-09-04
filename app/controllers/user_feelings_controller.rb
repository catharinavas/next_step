class UserFeelingsController < ApplicationController
  before_action :set_feeling, only: %i[edit update]

  def show

  end

  def new
    @feelings = Feeling.all
    @user_feeling = UserFeeling.new
  end

  def create
    @user_feeling = UserFeeling.new(user_feeling_params)
    @user_feeling.user = current_user
    @user_feeling.feeling_date = Date.today

    @feeling_today = current_user.user_feelings.where(feeling_date: @user_feeling.feeling_date, feeling: @user_feeling.feeling).uniq
    unless @feeling_today.count.zero?
      if (@feeling_today.first.user == @user_feeling.user || @feeling_today.first.feeling == @user_feeling.feeling)
        @feeling_today.first.update(user_feeling_params)
        dashboard_path(current_user)
      end
    end

    if @user_feeling.save!
      redirect_to dashboard_path(current_user)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user_feeling.update(user_feeling_params)
      respond_to do |format|
        format.html { redirect_to dashboard_path(current_user)}
        format.json
      end
    else
      render edit_user_feeling(@user_feeling)
    end
  end

  private

  def user_feeling_params
     params.require(:user_feeling).permit(:feeling_id, :intensity)
  end

  def set_feeling
    @user_feeling = UserFeeling.find(params[:id])
  end
end
