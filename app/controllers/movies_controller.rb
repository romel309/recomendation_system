class MoviesController < ApplicationController
    def index
        @movies = Movie.paginate(page: params[:page], per_page: 30)
    end
end
