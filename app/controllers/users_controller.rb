class Cosine
  def initialize vecA, vecB
    @vecA = vecA
    @vecB = vecB
  end

  def calculate_similarity
    return nil unless @vecA.is_a? Array
    return nil unless @vecB.is_a? Array
    return nil if @vecA.size != @vecB.size
    dot_product = 0
    @vecA.zip(@vecB).each do |v1i, v2i|
      dot_product += v1i * v2i
    end
    a = @vecA.map { |n| n ** 2 }.reduce(:+)
    b = @vecB.map { |n| n ** 2 }.reduce(:+)
    return dot_product / (Math.sqrt(a) * Math.sqrt(b))
  end
end

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
        #Hacer una matriz de 610 usuarios con 9187 peliculas
        #Llenarlas con los valores de las reviews
        matrix_recommended = Array.new
        centered_cosine = Array.new
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
            average=0
            sum_dividir_elements = 0
            aux = Array.new
            while (i < movies_identifiers.length)
                if index_of_movies_of_user[j] == movies_identifiers[i]
                    average+=ratings_of_user[j]
                    sum_dividir_elements+=1
                    aux.push(ratings_of_user[j])
                    j=j+1
                else
                    aux.push(0)
                end
                i = i+1
            end
            centered_cosine.push(average/sum_dividir_elements)
            matrix_recommended.push(aux)
            iterator = iterator+1
        end
        
        #Cambiar a centered cosine
        i=0
        while(i!=matrix_recommended.length)
        j=0
            while (j < matrix_recommended[i].length)
                if matrix_recommended[i][j] != 0
                    matrix_recommended[i][j]=matrix_recommended[i][j]-centered_cosine[i].to_f
                end
                j=j+1
            end
        i=i+1
        end
        
        
        #Aqui termina el while
        #puts "Total of movies #{matrix_recommended[0]}."
        #puts "Funciono centered cosine? #{centered_cosine}."
    
        #Encontrar los 10 usaurios más similares con cosine rule haciendo 610 operaciones entre filas 
        #y guardandolos en un arreglo
        iterator = 0
        user_to_compare = Array.new
        lalin = params[:id].to_i
        #Test cases for user number 503
        if (lalin==503)
            #matrix_recommended[502][314]=0
            #matrix_recommended[502][277]=0
            #matrix_recommended[502][257]=0
            #matrix_recommended[502][418]=0
            #matrix_recommended[502][418]=0
            #matrix_recommended[502][461]=0
            #matrix_recommended[502][659]=0
            #matrix_recommended[502][915]=0
            #matrix_recommended[502][1503]=0
            #matrix_recommended[502][2226]=0
            #matrix_recommended[502][510]=0
        end
        
        user_to_compare = matrix_recommended[lalin-1]
        list_similarity_user = Array.new
        while (iterator < matrix_recommended.length)
            cust1 = Cosine.new(user_to_compare, matrix_recommended[iterator])
            res=cust1.calculate_similarity
            if(res.to_f.nan?)
                res=0
            end
            list_similarity_user.push(res)
            iterator=iterator+1
        end

        #Index of the 10 similar users
        aux_list_similarity_user = list_similarity_user
        max_similarity_users = Array.new
        index_similarity_users = Array.new
        i = 0
        while (i < 30)
            max_value = aux_list_similarity_user.max
            max_similarity_users.push(max_value)
            index_value = aux_list_similarity_user.index(max_value)
            index_similarity_users.push(index_value)
            aux_list_similarity_user[index_value] = 0
            i=i+1
        end
        
        @most_similar_users = index_similarity_users
        
        i=0
        division = max_similarity_users.inject(:+)
        puts "division #{max_similarity_users}."
        new_ratings_user_to_compare = user_to_compare
        while (i < user_to_compare.length)
            j=0
            aux_max_similarity_users=max_similarity_users
            num = Array.new
            if user_to_compare.at(i) == 0
                #predict
                while (j < max_similarity_users.length)
                    num.push(matrix_recommended[index_similarity_users[j]][i])
                    j=j+1
                end
            else
                user_to_compare[i]=0
            end
    
            num.zip(aux_max_similarity_users).map{|x, y| x * y}
            amor = num.inject(0){|sum,x| sum + x }
            if amor>0
                new_ratings_user_to_compare[i]=amor/division
            end
            i=i+1
        end
        
        if lalin==503
        puts "movie id 314 #{new_ratings_user_to_compare[314]}."
        puts "movie id 277 #{new_ratings_user_to_compare[277]}."
        puts "movie id 257 #{new_ratings_user_to_compare[257]}."
        puts "movie id 418 #{new_ratings_user_to_compare[418]}."
        puts "movie id 461 #{new_ratings_user_to_compare[461]}."
        puts "movie id 659 #{new_ratings_user_to_compare[659]}."
        puts "movie id 915 #{new_ratings_user_to_compare[915]}."
        puts "movie id 1503 #{new_ratings_user_to_compare[1503]}."
        puts "movie id 2226 #{new_ratings_user_to_compare[2226]}."
        puts "movie id 510 #{new_ratings_user_to_compare[510]}."
        end

        matrix_movies = Array.new
        i = 0
        while (i < 10)
            aux_matrix_movies = Array.new
            max_movie_value = new_ratings_user_to_compare.max
            index_max_movie_value = new_ratings_user_to_compare.index(max_movie_value)
            new_ratings_user_to_compare[index_max_movie_value]=0
            aux_matrix_movies.push(movies_identifiers[index_max_movie_value])
            aux_matrix_movies.push(max_movie_value)
            matrix_movies.push(aux_matrix_movies)
            i=i+1
        end
        
        @movies_to_recomend=matrix_movies
     
        #Mostrar los ratings del usuario
        @users_ratings = Rating.where("user_id = ?", params[:id]).paginate(page: params[:page], per_page: 10)
    end
end
