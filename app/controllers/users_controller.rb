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
        
         puts "Funciono cosine similarity? #{list_similarity_user}."
        
       
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
                    #sum+=(matrix_recommended[index_similarity_users[j]][i]*max_similarity_users[j])
                    num.push(matrix_recommended[index_similarity_users[j]][i])
                    j=j+1
                end
                
                if i==1
                    puts "si entra"
                end
            else
                user_to_compare[i]=0
            end
    
            num.zip(aux_max_similarity_users).map{|x, y| x * y}
            amor = num.inject(0){|sum,x| sum + x }
            if lalin==1
                #puts "user_to_compare #{user_to_compare[1]}"
                puts "j #{j}"
                #puts "index_similarity_users #{index_similarity_users}."
                puts "array max_similarity_users #{max_similarity_users}."
                #puts "max_similarity_users #{max_similarity_users}."
                puts "ayuda #{matrix_recommended[index_similarity_users[0]][2]}."
                puts "ayuda #{matrix_recommended[index_similarity_users[1]][2]}."
                puts "ayuda #{matrix_recommended[index_similarity_users[2]][2]}."
                puts "ayuda #{matrix_recommended[index_similarity_users[3]][2]}."
                puts "ayuda #{matrix_recommended[index_similarity_users[4]][2]}."
                puts "ayuda #{matrix_recommended[index_similarity_users[5]][2]}."
                puts "ayuda #{matrix_recommended[index_similarity_users[6]][2]}."
                puts "ayuda #{matrix_recommended[index_similarity_users[7]][2]}."
                puts "ayuda #{matrix_recommended[index_similarity_users[8]][2]}."
                puts "ayuda #{matrix_recommended[index_similarity_users[9]][2]}."
                puts "sum #{num}."
                puts "amor #{amor}."
            end
            if amor>0
                new_ratings_user_to_compare[i]=amor/division
            end
            i=i+1
        end
        
        if lalin==1
        puts "division #{division}."
        puts "movie id 2 #{new_ratings_user_to_compare[2]}."
        puts "movie id 5 #{new_ratings_user_to_compare[5]}."
        puts "movie id 47 #{new_ratings_user_to_compare[43]}."
        puts "movie id 50 #{new_ratings_user_to_compare[46]}."
        puts "movie id 70 #{new_ratings_user_to_compare[62]}."
        puts "movie id 101 #{new_ratings_user_to_compare[89]}."
        puts "movie id 110 #{new_ratings_user_to_compare[97]}."
        puts "movie id 151 #{new_ratings_user_to_compare[124]}."
        puts "movie id 157 #{new_ratings_user_to_compare[130]}."
        #puts "Length #{list_similarity_user.length}."
        end
        
        if lalin==2
        puts "division #{division}."
        puts "movie id 318 #{new_ratings_user_to_compare[277]}."
        puts "movie id 333 #{new_ratings_user_to_compare[291]}."
        puts "movie id 1704 #{new_ratings_user_to_compare[1284]}."
        puts "movie id 2578 #{new_ratings_user_to_compare[2674]}."
        puts "movie id 4615 #{new_ratings_user_to_compare[6874]}."
        puts "movie id 8798 #{new_ratings_user_to_compare[5305]}."
        puts "movie id 46970 #{new_ratings_user_to_compare[6253]}."
        puts "movie id 48516 #{new_ratings_user_to_compare[6315]}."
        puts "movie id 58559 #{new_ratings_user_to_compare[6710]}."
        puts "movie id 6804 #{new_ratings_user_to_compare[6801]}."
        #puts "Length #{list_similarity_user.length}."
        end
        
        
        #Prediccion de peliculas
        #Mostrar las peliculas
        matrix_movies = Array.new
        #max_similarity_movies = Array.new
        #index_similarity_movies = Array.new
        i = 0
        while (i < 30)
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
