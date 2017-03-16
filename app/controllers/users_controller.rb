class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin, only: [:destroy]
  def new
  	@user=User.new
  end
  def show
  	@user=User.find_by_id(params[:id])
  end
  def create
  	@user=User.new(params_user)
  	if @user.save
      log_in @user
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to user_path(@user)
  	else
  		render 'new'
  	end
  end
  def edit
    @user=User.find(params[:id])
  end
  def update
    @user=User.find(params[:id])
    if @user.update_attributes(params_user)
      flash[:success]="Profile updated!"
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end
  def index
    @users=User.paginate(page: params[:page])
  end
  def logged_in_user
    if !logged_in?
      flash[:danger]="Please log in"
      redirect_to login_path
    end
  end
  def correct_user
    @user=User.find(params[:id])
    redirect_to root_url unless @user==current_user
  end
  def destroy
    User.find(params[:id]).destroy
    flash[:success]="User Deleted"
    redirect_to users_url
  end
  def admin
    redirect_to(root_url) unless current_user.admin?
  end
  private
  def params_user
  	params.require(:user).permit(:name,:email,:password, :password_confirmation)
  end
end
