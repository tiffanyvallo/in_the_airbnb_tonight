require 'property'

describe Property do
  let(:property) {Property.new(id: 1, postcode: 'E19 4RH', title: 'Dummy property listing', description: 'generic property info', user_id: "1", price_per_day: 100)}
  
  # let(:user_double) { double(:user, id: "1", name: "Finn", email: "finn@email.com") }
  # let(:user_double_2) { double(:user, id: "2", name: "Matt", email: "matt@email.com") } 

  #  *** couldn't get test doubles to work with databases - possible issues of doubles not existing in databases.

  context '#initialize' do
    it 'should have attributes' do
      expect(property.id).to eq 1
      expect(property.postcode).to eq 'E19 4RH'
      expect(property.title).to eq 'Dummy property listing'
      expect(property.description).to eq 'generic property info'
      # expect(property.user_id).to eq 
      expect(property.price_per_day).to eq 100
    end

    it 'stores a user id' do
      user = User.create('test name', "test@email.com", 'password1234')
      property = Property.create(address: '123 fake street', postcode: 'E19 4RH', title: 'Dummy property listing', description: 'generic property info', user_id: user.id, price_per_day: 100)

      expect(property.user_id).to eq user.id
    end
  end

  context '.create' do
    it 'should create a new instance of Property' do
      user = User.create('test name', "test@email.com", 'password1234')
      property = Property.create(address: '123 fake street', postcode: 'E19 4RH', title: 'Dummy property listing', description: 'generic property info', user_id: user.id, price_per_day: 100)

      expect(property.description).to eq 'generic property info'
      expect(property.postcode).to eq 'E19 4RH'
    end
  end

  context '.all' do
    it 'should return existing properties' do
      user = User.create('test name', "test@email.com", 'password1234')
      user_2 = User.create('test name 2', "test2@email.com", 'password12345')
      property_1 = Property.create(address: '123 fake street', postcode: 'E19 4RH', title: 'Dummy property listing', description: 'generic property info', user_id: user.id, price_per_day: 100)
      property_2 = Property.create(address: '124 fake street', postcode: 'E20 4RH', title: 'illusion property listing', description: 'misleading property info', user_id: user_2.id, price_per_day: 150)

      properties = Property.all

      expect(properties.size).to eq 2
      expect(properties.first.description).to eq 'generic property info'
      expect(properties.last.description).to eq 'misleading property info'
      expect(properties.first.price_per_day).to eq 100
      expect(properties.last.price_per_day).to eq 150
      #converts to integer to be stored for easy manipulation and calculation, can interpolate into views. possibly change to string?
    end
  end
end
