class BasketsController < ApplicationController
  # GET /baskets
  # GET /baskets.xml
  PRICING_RULES = { 
          "FR1" => { 
            "discount_name" => "BOGOF", 
            "discount_multiple" => 2, 
            "discount_amount" => 0,
            "discount_message" => "Buy One Get One Free: "},
          "SR1" => { 
            "discount_name" => "MULTIBUY",
            "discount_multiple" => 3, 
            "discount_amount" => 50,
            "discount_message" => "Multibuy - Reduced price on 3 or more: "}
  }
  #PRICING_RULES = { "FR1" => "QUANTITY > 1, PRICE % 2 == 0?  CTOTAL = PRICE * QUANTITY / 2, PRICE % == 1? CTOTAL = PRICE * QUANTITY /2 + 1" , "SR1" => "QUANTITY >= 3, PRICE = 450"}

  def checkout(pricing_rules=PRICING_RULES)

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
    @discount_type = ""  
    @info_messages = Array.new

    @line_items.each do |i|
      @discount_type = ""

      if pricing_rules[@products[j]['product_code']]
        if i.quantity >= pricing_rules[@products[j]['product_code']]['discount_multiple']
          @info_messages[j] = pricing_rules[@products[j]['product_code']]['discount_message'] + " " + @products[j]['name']
          @discount_type = pricing_rules[@products[j]['product_code']]['discount_name']

          if @discount_type == "BOGOF"

            if i.quantity % 2 == 0
              @checkout_total += @products[j]['price'] * (i.quantity / 2)
            else 
              @checkout_total += @products[j]['price'] * ((i.quantity / 2) + 1)
            end
          end

          if @discount_type == "MULTIBUY"

            @checkout_total += (((@products[j]['price']) - (pricing_rules[@products[j]['product_code']]['discount_amount'])) * i.quantity)

          end

        else
          @info_messages[j] = "Not enough items purchased to qualify for discount - "  + @products[j]['name']
          @checkout_total += @products[j]['price']  * i.quantity
        end
      else
        @checkout_total += @products[j]['price']  * i.quantity
      end

      @display_data[j] = Hash.new
      @display_data[j] = {:product_id => i.product_id, 
              :product_code => @products[j]['product_code'], 
              :name => @products[j]['name'], 
              :quantity => i.quantity,
              :price => @products[j]['price']}

      @basket_total += @products[j]['price'] * i.quantity

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
