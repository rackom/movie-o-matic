class ScreeningsController < ApplicationController
  # GET /screenings
  # GET /screenings.xml
  def index
    @screenings = Screening.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @screenings }
    end
  end

  # GET /screenings/1
  # GET /screenings/1.xml
  def show
    @screening = Screening.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @screening }
    end
  end

  # GET /screenings/new
  # GET /screenings/new.xml
  def new
    @screening = Screening.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @screening }
    end
  end

  # GET /screenings/1/edit
  def edit
    @screening = Screening.find(params[:id])
  end

  # POST /screenings
  # POST /screenings.xml
  def create
    @screening = Screening.new(params[:screening])

    respond_to do |format|
      if @screening.save
        format.html { redirect_to(@screening, :notice => 'Screening was successfully created.') }
        format.xml  { render :xml => @screening, :status => :created, :location => @screening }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @screening.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /screenings/1
  # PUT /screenings/1.xml
  def update
    @screening = Screening.find(params[:id])

    respond_to do |format|
      if @screening.update_attributes(params[:screening])
        format.html { redirect_to(@screening, :notice => 'Screening was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @screening.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /screenings/1
  # DELETE /screenings/1.xml
  def destroy
    @screening = Screening.find(params[:id])
    @screening.destroy

    respond_to do |format|
      format.html { redirect_to(screenings_url) }
      format.xml  { head :ok }
    end
  end
end
