require 'pg'


class Property

  attr_reader :id, :postcode, :title, :description, :price_per_day
  
  def initialize(id:, postcode:, title:, description:, price_per_day:)
    @id = id
    @postcode = postcode
    @title = title
    @description = description
    @price_per_day = price_per_day
  end

  #do the database stuff boyo

  def self.create(address:, postcode:, title:, description:, price_per_day:)
    if ENV['RACK_ENV'] == 'test'
      connection = PG.connect(dbname: 'airbnb_test')
    else
      connection = PG.connect(dbname: 'airbnb')
    end
    result = connection.exec("INSERT INTO properties (address, postcode, title, description, price_per_day) VALUES('#{address}', '#{postcode}', '#{title}', '#{description}', '#{price_per_day}') RETURNING id, postcode, title, description, price_per_day;")
    Property.new(id: result[0]['id'], postcode: result[0]['postcode'], title: result[0]['title'], description: result[0]['description'], price_per_day: result[0]['price_per_day'])
  end

end