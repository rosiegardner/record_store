require('pry')

# Our mock database will be a hash. In addition to being efficient, hashes are a common data structure used in databases. (An array is much more inefficient.) We'll use a class variable for our mock database so any method inside our Album class can access it.
# Lets consider the methods we'll need to implement CRUD functionality


class Album
  attr_reader :id, :name 

  @@albums = {}
  @@total_rows = 0 

  def initialize(name, id)
    @name = name
    @id = id || @@total_rows += 1 
  end

  def self.all
    @@albums.values()
  end

  def self.clear
    @@albums = {}
    @@total_rows = 0
  end

  def self.find(id)
    @@albums[id]
  end

  def self.search(str)
    album_search = @@albums.find { |album| album[1].name.downcase == str.downcase }
    album_search[1] 
  end

  def save
    @@albums[self.id] = Album.new(self.name, self.id)
  end

  def ==(album_to_compare)
    self.name() == album_to_compare.name()
  end

  def update(name)
    @name = name
  end

  def delete
    @@albums.delete(self.id)
  end

  def songs
    Song.find_by_album(self.id)
  end

 

end