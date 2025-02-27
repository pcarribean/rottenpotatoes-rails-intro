class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if request.env['PATH_INFO'] == '/'
      session.clear
    end

    if params[:sort_by]
      session[:sort_by] = params[:sort_by]
      @sort_key = params[:sort_by]
    elsif session[:sort_by]
      @sort_key = session[:sort_by]
    end
    
    #@sort_key = params[:sort_by]
    
    @all_ratings = Movie.get_all_ratings_types
    ratings = params[:ratings].nil? ? ((session[:ratings_selected].nil? ) ? @all_ratings : session[:ratings_selected]) : params[:ratings].keys
    #ratings = params[:ratings].nil? ? @all_ratings : params[:ratings].keys
    @ratings_selected = ratings
    
    @movies = Movie.with_ratings(ratings).order(@sort_key)
    
    session[:ratings_selected] = ratings
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
