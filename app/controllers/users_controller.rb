class UsersController < ApplicationController
  before_filter :authenticate_user!
  after_action :verify_authorized, except: :new

  def index
    @users = User.all
    authorize User
  end

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  #def new
    #@name = session["devise.google_data"]['info']['name']
    #@email = session["devise.google_data"]['info']['email']
  #end


  def edit
    @user = User.find(params[:id])
    authorize @user
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "Account for #{@user.name} was successfully updated."
    else
      redirect_to users_path, :alert => "Unable to update user account for #{@user.name}."
    end
  end

  def destroy
    user = User.find(params[:id])
    authorize user
    user.destroy
    redirect_to users_path, :notice => "Account for #{@user.name} successfully deleted."
  end

  private
    def secure_params
      params.require(:user).permit(:role)
    end

end
