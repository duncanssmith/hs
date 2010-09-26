class CheckoutsController < ApplicationController
  # GET /checkouts
  # GET /checkouts.xml
  def index
    @checkouts = Checkout.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @checkouts }
    end
  end

  # GET /checkouts/1
  # GET /checkouts/1.xml
  def show
    @checkout = Checkout.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @checkout }
    end
  end


  # DELETE /checkouts/1
  # DELETE /checkouts/1.xml
  def destroy
    @checkout = Checkout.find(params[:id])
    @checkout.destroy

    respond_to do |format|
      format.html { redirect_to(checkouts_url) }
      format.xml  { head :ok }
    end
  end
end
