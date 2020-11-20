class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    #- used with gem byebug, to initiate debug mode
    # also works with 'byebug' command
    #debugger 
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user]) # Not the final implementation!
    if @user.save
      # Handle a successful save.
    else
      render 'new'
    end
  end
  
end
