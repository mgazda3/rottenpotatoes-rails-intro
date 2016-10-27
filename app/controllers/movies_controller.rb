class MoviesController < ApplicationController
  helper_method :highlight
  helper_method :rating?
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #@movies = Movie.all
    @all_ratings = Movie.all_ratings
    
    session[:ratings] = params[:ratings] unless params[:ratings].nil?
    
    session[:sort_by] = params[:sort_by] unless params[:sort_by].nil?

    if (params[:ratings].nil? and !session[:ratings].nil?) or (params[:sort_by].nil? and !session[:sort_by].nil?)
      redirect_to movies_path(:ratings => session[:ratings], :sort_by => session[:sort_by])
    end
    
    
    
    @ratings = params[:ratings]
    if params[:ratings].present?
      @movies = Movie.where(rating: params[:ratings].keys).order(params[:sort_by])
      
      
    else
      @movies = Movie.all
    end
    
    #if (params[:sort_by])
      
      
    #end
    
    if !session[:ratings].nil? or !session[:sort_by].nil?
     
    else
      return @movies = Movie.all
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def highlight(column)
    if(session[:sort_by].to_s == column)
      return 'hilite'
    else
      return ''
    end
  end

  def rating?(rating)
    temp = session[:ratings]
    return true if temp.nil?
    temp.include? rating
  end
end