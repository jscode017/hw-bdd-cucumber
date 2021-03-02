class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings=Movie.all_ratings
    if !params.include?(:notFirst)
      session.clear
    end
    if !params.include?(:ratings) && !session.include?(:ratings)
      @movies=Movie.all
      @ratings_to_show=[]
      session[:ratings]=Hash.new
    elsif params.include?(:ratings)
      @ratings_to_show=params[:ratings].keys
      if @ratings_to_show.length==0
        @rating_to_show=[]
      end
      @movies=Movie.with_ratings(@ratings_to_show)
      session[:ratings]=params[:ratings]
    elsif params.include?(:commit)
      @movies=Movie.all
      @ratings_to_show=[]
      session[:ratings]=Hash.new
    elsif 
      @ratings_to_show=session[:ratings].keys
      if @ratings_to_show.length==0
        @rating_to_show=[]
      end
      @movies=Movie.with_ratings(@ratings_to_show)
    end
    @selected_ratings=@ratings_to_show
    @sort_by=''
    if params.include?(:sort)
      @sort_by=params[:sort]
      session[:sort]=params[:sort]
    elsif session.include?(:sort)
      @sort_by=session[:sort]
    end
    
    if @sort_by=='title'
      @movies=@movies.order('title')
    elsif @sort_by=='release_date'
      @movies=@movies.order('release_date')
    end
  end
=begin
    sort = params[:sort] || session[:sort]
    case sort
    when 'title'
      ordering,@title_header = {:title => :asc}, 'bg-warning hilite'
    when 'release_date'
      ordering,@date_header = {:release_date => :asc}, 'bg-warning hilite'
    end
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}

    if @selected_ratings == {}
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end

    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      session[:sort] = sort
      session[:ratings] = @selected_ratings
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end
    @movies = Movie.where(rating: @selected_ratings.keys).order(ordering)
=end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path, :notFirst=> true
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie), :notFirst=> true
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path, :notFirst=> true
  end
  
  private
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end

end
