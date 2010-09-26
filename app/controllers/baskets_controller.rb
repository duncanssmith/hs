class BasketsController < ApplicationController
  # GET /baskets
  # GET /baskets.xml

	def checkout

    @basket = Basket.find(params[:id])
		@line_items = @basket.line_items
    @products = Array.new

    @line_items.each do |item|
      @products << Product.find(item.product_id)
		end

		@display_data = Hash.new
    j = 0 
		@basket_total = 0
		@checkout_total = 0

	  @bogof = false	
	  @bogofx = ""	
	  @multibuy = false	
	  @multibuyx = ""	

		@line_items.each do |i|

			if (@products[j]['product_code'] == 'FR1')
				if (i.quantity >= 2)
          @bogof = true
				end
			end
		  	
			if @products[j]['product_code'] == 'SR1'
				if i.quantity >= 3
          @multibuy = true
				end
			end
		  	
			@display_data[j] = Hash.new
			@display_data[j] = {:product_id => i.product_id, 
							:product_code => @products[j]['product_code'], 
							:name => @products[j]['name'], 
							:quantity => i.quantity,
							:price => @products[j]['price']
			}
			
      @basket_total += @products[j]['price'] * i.quantity
      
			if @bogof
				if i.quantity % 2 ==0
          @checkout_total += @products[j]['price'] * (i.quantity / 2)
				else
          @checkout_total += @products[j]['price'] * ((i.quantity / 2) + 1)
				end
				@bogofx = "FRUIT TEA"
			elsif @multibuy
        @checkout_total += (@products[j]['price'] - 50) * i.quantity
				@multibuyx = "STRAWBERRIES"
			else
        @checkout_total += @products[j]['price']  * i.quantity
			end

			@bogof = false
			@multibuy = false

			j += 1
		end
   
	 co = Checkout.new
	 co.basket_id = @basket.id
	 co.subtotal = @basket_total 
	 co.savings = @basket_total - @checkout_total
	 co.total = @checkout_total
   co.save



	end


  def index
    @baskets = Basket.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @baskets }
    end
  end

  # GET /baskets/1
  # GET /baskets/1.xml
  def show
    @basket = Basket.find(params[:id])
		#@line_items = LineItem.find(@basket.id)
    @line_items = @basket.line_items
   
		@products = Array.new
    @line_items.each do |item|
      @products << Product.find(item.product_id)
		end

		@display_data = Hash.new
    j = 0 
		@basket_total = 0
		@line_items.each do |i|
			@display_data[j] = Hash.new
			@display_data[j] = {:product_id => i.product_id, 
							:product_code => @products[j]['product_code'], 
							:name => @products[j]['name'], 
							:quantity => i.quantity,
							:price => @products[j]['price']
			}
      @basket_total += @products[j]['price'] * i.quantity
			j += 1
		end






    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @basket }
    end
  end

  # GET /baskets/new
  # GET /baskets/new.xml
  def new
    @basket = Basket.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @basket }
    end
  end

  # GET /baskets/1/edit
  def edit
    @basket = Basket.find(params[:id])
  end

  # POST /baskets
  # POST /baskets.xml
  def create
    @basket = Basket.new(params[:basket])

    respond_to do |format|
      if @basket.save
        format.html { redirect_to(@basket, :notice => 'Basket was successfully created.') }
        format.xml  { render :xml => @basket, :status => :created, :location => @basket }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @basket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /baskets/1
  # PUT /baskets/1.xml
  def update
    @basket = Basket.find(params[:id])

    respond_to do |format|
      if @basket.update_attributes(params[:basket])
        format.html { redirect_to(@basket, :notice => 'Basket was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @basket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /baskets/1
  # DELETE /baskets/1.xml
  def destroy
    @basket = Basket.find(params[:id])
    @basket.destroy

    respond_to do |format|
      format.html { redirect_to(baskets_url) }
      format.xml  { head :ok }
    end
  end
end
