class Product < ActiveRecord::Base
    validates :price,
      numericality: {
        greater_than_or_equal_to: 0,
        less_than_or_equal_to: 999999.99,
        message: 'Price must be a number between 0 - 999999.99'
      }

end
