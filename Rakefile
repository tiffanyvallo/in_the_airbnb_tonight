require 'pg'

task :setup do
  p "Creating databases..."

  ['airbnb', 'airbnb_test'].each do |database|
    connection = PG.connect
    connection.exec("CREATE DATABASE #{ database };")
    connection = PG.connect(dbname: database)
    connection.exec("CREATE TABLE users (id SERIAL PRIMARY KEY,
      email VARCHAR (50) UNIQUE,
      password VARCHAR (100),
      name VARCHAR (50)
    );")
    connection.exec("CREATE TABLE properties (id SERIAL PRIMARY KEY,
      address VARCHAR(100),
      postcode VARCHAR(10),
      title VARCHAR (60),
      description VARCHAR (240),
      user_id INT,
      FOREIGN KEY (user_id) REFERENCES users (id),
      price_per_day INT
    );")
    end
  end
