class Checkout < ActiveRecord::Base
  pricing_rule = Hash.new
	pricing_rule = { "FR1" => "BOGOF", "SR1" => "MULTIBUY" }

	BOGOF = 2
	MULTIBUY = 3
	
end
