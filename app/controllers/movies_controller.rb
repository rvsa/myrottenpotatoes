class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def check(rating)
    if params[:ratings] != nil
      params[:ratings].keys.include?(rating)
    else
      @all_ratings = Movie.getRatings
      h = Hash.new(0)
      @all_ratings.each {|r| h[r]=1}
      params[:ratings] = h
    end
  end

  helper_method :check

  def setBG(column)
    sort = params[:sort]
    if (sort != nil)
      if (sort == column)
        "hilite"
      else
        ""
      end
    end
  end

  helper_method :setBG

  def index
    @all_ratings = Movie.getRatings
    
   
    if (request.fullpath == "/movies" && session[:params] != nil)      
      redirect_to(session[:params])
    end    
    session[:params] = params
    sort = params[:sort]
    if (sort != nil)
      @movies = Movie.order(sort)
    else
      sort = ""
    end

    if (params[:ratings] != nil)
      @check = true
      @movies = Movie.find :all, :conditions => { :rating => params[:ratings].keys}, :order => sort
    else
      @check = false
      @movies = Movie.find :all, :order => sort
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

end
