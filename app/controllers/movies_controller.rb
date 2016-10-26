class MoviesController < ApplicationController
  
  

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    
    
    if params[:sort_by].nil? and params[:ratings].nil? and (!session[:sort_by].nil? or !session[:ratings].nil?)
      redirect_to movies_path(:sort_by => session[:sort_by], :ratings => session[:ratings])
    end
    
    
   
    
    
    
    
    #@movies = Movie.all
    @ratings = params[:ratings]
    if params[:ratings].present?
      @movies = Movie.where(rating: params[:ratings].keys)
      
    else
      @movies = Movie.all
    end
    
    
    
    if (params[:sort_by])
      @movies = Movie.all.order(params[:sort_by])
      
    end
    
    
    session[:ratings] = @ratings
    session[:sort_by] = @sort_by
    
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
