class UsersController < ApplicationController
    def index
        @users = User.all
    end
    
    def show 
        @users = Rating.find(params[:id])
    end
end
