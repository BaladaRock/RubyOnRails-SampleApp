class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    #also works with 'byebug' command
    #debugger - used with gem byebug, to initiate debug mode
  end

  def new
  end
  
end
