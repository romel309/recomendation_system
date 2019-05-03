class UsersController < ApplicationController
    def index
        @users = User.paginate(page: params[:page], per_page: 30)
    end
    
    def show 
        #Hacer un arreglo con los id de las peliculas
        movies_identifiers = Array.new
        @m = Movie.select("id")
        @m.each do |m|
            movies_identifiers.push(m.id)
        end 
        #@prueba = movies_identifiers
        #Hacer una matriz de 610 usuarios con 9187 peliculas
        #Llenarlas con los valores de las reviews
        matrix_recommended = Array.new
        #Aqui va a ir un for de 610
        iterator = 1
        while (iterator < 611)
            index_of_movies_of_user = Array.new
            ratings_of_user = Array.new
            @user = Rating.where("user_id = ?", iterator)
            @user.each do |user|
                #index_of_movies_of_user.push(movies_identifiers.index(user.movie_id))
                index_of_movies_of_user.push(user.movie_id)
                ratings_of_user.push(user.rating)
            end
            i=0
            j=0
            aux = Array.new
            while (i < movies_identifiers.length)
                if index_of_movies_of_user[j] == movies_identifiers[i]
                    aux.push(ratings_of_user[j])
                    j=j+1
                else
                    aux.push(0)
                end
                i = i+1
            end
            
            #puts "Total of movies #{movies_identifiers.length}."
            #puts "Index of movies #{index_of_movies_of_user.length}."
            #puts "ratings of users #{ratings_of_user.length}."
            #puts "New vector of users #{aux.length}."
            #puts "movies identifiers #{movies_identifiers.at(0)}."
            #puts "index_movies_of_user #{index_of_movies_of_user.at(0)}."
            #puts "jota #{j}"
            
            
            matrix_recommended.push(aux)
            iterator = iterator+1
        #Aqui termina el for de 610
        end
        
        puts "Total of movies #{matrix_recommended.length}."
        
        #@aux = aux
      
        #Encontrar los 10 usaurios más similares con cosine rule haciendo 610 operaciones entre filas 
        #y guardandolos en un arreglo
        #Mañana investigar como hacer la predicción
        
        #@users = Rating.find(params[:id])
        @users_ratings = Rating.where("user_id = ?", params[:id]).paginate(page: params[:page], per_page: 10)
        
        #@users_ratings.each do |user|
            #ary.push(user.rating)
        #end 
        
    end
end
