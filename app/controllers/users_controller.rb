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
            
            matrix_recommended.push(aux)
            iterator = iterator+1
        end
        #Aqui termina el while
        #puts "Total of movies #{matrix_recommended.length}."
      
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
            list_similarity_user.push(res)
            iterator=iterator+1
        end
        
=begin
        while (iterator < matrix_recommended.length)
            sum = 0
            dot_cros_user = 0
            dot_cross_user2 = 0
            i=0
            j=0
            #user_to_compare.each do |element|
            while (j < user_to_compare.length)
                user_to_compare.zip(matrix_recommended).map{|x, y| x * y}
                sum = sum + (user_to_compare[j]*matrix_recommended[iterator][i])
                dot_cros_user = dot_cros_user+(user_to_compare[j]**2)
                dot_cross_user2 = dot_cross_user2+(matrix_recommended[iterator][i]**2)
                j=j+1
            end
            if iterator==1
                puts "sum #{sum}."
                puts "dot_cros_user #{dot_cros_user}."
                puts "dot_cross_user2 #{dot_cross_user2}."
                puts "sqrt dot_cross_user #{Math.sqrt(dot_cros_user)}."
                puts "sqrt dot_cross_user2 #{Math.sqrt(dot_cross_user2)}."
            end    
            res = sum/(Math.sqrt(dot_cros_user)*Math.sqrt(dot_cross_user2))
            if iterator==1
                puts "res #{res}."
            end
            list_similarity_user.push(res)
            iterator = iterator+1
        end
=end
        
        puts "max #{list_similarity_user.at(1)}."
        #puts "Length #{list_similarity_user.length}."
        
        #Prediccion de peliculas
        
        #Mostrar los ratings del usuario
        @users_ratings = Rating.where("user_id = ?", params[:id]).paginate(page: params[:page], per_page: 10)
        
    end
end
