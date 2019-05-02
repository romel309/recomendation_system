class RaitingsController < ApplicationController
    def show 
        @raitings = Raiting.find(params[:id])
    end
end
