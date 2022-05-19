class Album
  attr_reader :id
  attr_accessor :name

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def self.all
    returned_albums = DB.exec("SELECT * FROM albums;")
    albums = []
    returned_albums.each() do |album|
      name = album.fetch("name")
      id = album.fetch("id").to_i
      albums.push(Album.new({:name => name, :id => id}))
    end
    albums
  end

  def self.clear
    DB.exec("DELETE FROM albums *;")
  end

  def self.find(id)
    album = DB.exec("SELECT * FROM albums WHERE id = #{id};").first
    if album
      name = album.fetch("name")
      id = album.fetch("id").to_i
      Album.new({:name => name, :id => id})
    else
      nil
    end
  end

  def save
    result = DB.exec("INSERT INTO albums (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end
  
  def ==(album_to_compare)
    self.name() == album_to_compare.name()
  end
  
  def update(attributes) 
    if (attributes.has_key?(:name)) && (attributes.fetch(:name) != nil)
      @name = attributes.fetch(:name) 
      DB.exec("UPDATE albums SET name = '#{@name}' WHERE id = #{@id};")
    elsif (attributes.has_key?(:artist_name)) && (attributes.fetch(:artist_name) != nil)
      artist_name = attributes.fetch(:artist_name)
      artist = DB.exec("SELECT * FROM artists WHERE lower(name)='#{artist_name.downcase}';").first
      if artist != nil
        DB.exec("INSERT INTO albums_artists (artist_id, album_id) VALUES (#{artist['id'].to_i}, #{@id});")
      end
    end
  end 

  # def update(x)
  #   @name = x
  #   DB.exec("UPDATE albums SET name = '#{@name}' WHERE id = #{@id};")
  # end
  
  def delete
    DB.exec("DELETE FROM albums WHERE id = #{@id};")
    DB.exec("DELETE FROM songs WHERE album_id = #{@id};")
  end
  
  def songs
    find = Song.find_by_album(self.id)
    if find.any?
      find
    end
  end

  # def songs
  #   Song.find_by_album(self.id)
  # end

  def artists
    artists = []
    results = DB.exec("SELECT artist_id FROM albums_artists WHERE album_id = #{@id};")
    results.each() do |result|
      artist_id = result.fetch("artist_id").to_i()
      artist = DB.exec("SELECT * FROM artists WHERE id = #{artist_id};")
      name = artist.first().fetch("name")
      artists.push(Artist.new({:name => name, :id => artist_id}))
    end
    if artists.any?
      artists
    end
  end
  
  def self.search(str)
    result = DB.exec("SELECT * FROM albums WHERE name ILIKE '%#{str}%';")
    albums = []
    result.each() do |album|
      name = album.fetch("name")
      id = album.fetch("id").to_i
      albums.push(Album.new({:name => name, :id => id}))
    end
    if albums.any?
      albums
    end
  end
  
  
end