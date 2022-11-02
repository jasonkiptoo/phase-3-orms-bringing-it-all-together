class Dog
  attr_accessor :id, :name, :breed

  def initialize(id: nil, name:, breed:)
      @id = id
      @name = name
      @breed = breed
  end




  
  def self.create_table
      sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
          id INTEGER PRIMARY KEY,
          name text,
          breed text
      )
      SQL
      DB[:conn].execute(sql)
  end

  def self.drop_table
      sql = <<-SQL
      DROP TABLE IF EXISTS dogs
      SQL
      DB[:conn].execute(sql)
  end

  def save
      sql = <<-SQL
      INSERT INTO dogs (id, name, breed) VALUES (?, ?, ?)
      SQL

      DB[:conn].execute(sql, self.id, self.name, self.breed)

      self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
  end

  def self.create(name:, breed:)
      newDog = Dog.new(name: name, breed: breed)

      newDog.save
      newDog
  end

  def self.new_from_db(row)
      self.new(id: row[0], name: row[1], breed: row[2])
  end

  def self.all
      sql = <<-SQL
      SELECT * FROM dogs
      SQL
      DB[:conn].execute(sql).map {|row| self.new_from_db(row)}
  end


  def self.find_by_name(name)
      sql = <<-SQL
      SELECT * FROM dogs WHERE name =? LIMIT 1
      SQL
      DB[:conn].execute(sql, name).map {|row| self.new_from_db(row)}.first
  end

  def self.find(id)
      sql = <<-SQL
      SELECT * FROM dogs WHERE id=? LIMIT 1
      SQL
      DB[:conn].execute(sql, id).map {|row| self.new_from_db(row)}.first

  end


end
