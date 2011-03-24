class EmailaccountController < ApplicationController

  def index
    @emailaccount = Emailaccount.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @emailaccount }
    end
  end

  def show
    @emailaccount = Emailaccount.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @emailaccount }
    end
  end

  
  def new
    @emailaccount = Emailaccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @emailaccount }
    end
  end


  def edit
    @emailaccount = Emailaccount.find(params[:id])
  end


  def create
    @emailaccount = Emailaccount.new(params[:emailaccount])
    respond_to do |format|
      if @emailaccount.save
        format.html { redirect_to(@emailaccount, :notice => 'Emailaccount was successfully created.') }
        format.xml  { render :xml => @emailaccount, :status => :created, :location => @emailaccount }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @emailaccount.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @emailaccount = Emailaccount.find(params[:id])

    respond_to do |format|
      if @emailaccount.update_attributes(params[:emailaccount])
        format.html { redirect_to(@emailaccount, :notice => 'Emailaccount was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @emailaccount.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @emailaccount = Emailaccount.find(params[:id])
    @emailaccount.destroy

    respond_to do |format|
      format.html { redirect_to(emailaccount_url) }
      format.xml  { head :ok }
    end
  end
end
