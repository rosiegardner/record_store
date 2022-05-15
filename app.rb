require('sinatra')
require('sinatra/reloader')
require('./lib/album')
require('./lib/song')
require('pry')
also_reload('lib/**/*.rb')
require("pg")

DB = PG.connect({:dbname => "record_store"})

get('/test')do
  @something = "this is the @something variable"
  erb(:whatever)
end

get('/') do
  @albums = Album.all #update code pg18
  erb(:albums)
  # "This will be our home page. '/' is always the root route in a Sinatra application."
end

get('/results') do
  @album = Album.all
  erb(:search_results)
end

post('/results') do
  name = params[:album_name]
  album = Album.new({:name => name,:id => nil})
  album.save()
  @albums = Album.all
  erb(:search_results)
end

get('/albums') do
  # binding.pry #add code pg20 -GET VS POST
  @albums = Album.all #update code pg18
  erb(:albums)
  # "This route will show a list of all albums."
end

get('/albums/new') do
  erb(:new_album) #update code pg19
  # "This will take us to a page with a form for adding a new album."
end

get('/albums/:id') do
  @album = Album.find(params[:id].to_i()) #update code pg22
  erb(:album)
  # "This route will show a specific album based on its ID. The value of ID here is #{params[:id]}."
end

post('/albums') do
  name = params[:album_name] #update code pg19
  album = Album.new({:name => name,:id => nil})
  album.save()
  @albums = Album.all() #defined methoded - fixed error.
  erb(:albums)
  # binding.pry
  # "This route will add an album to our list of albums. We can't access this by typing in the URL. In a future lesson, we will use a form that specifies a POST action to reach this route."
end

get('/albums/:id/edit') do
  @album = Album.find(params[:id].to_i()) #update code pg23
  erb(:album)
  # "This will take us to a page with a form for updating an album with an ID of #{params[:id]}."
end

patch('/albums/:id') do
  @album = Album.find(params[:id].to_i()) #update code pg23
  @album.update(params[:name])
  @albums = Album.all
  erb(:albums)
  # "This route will update an album. We can't reach it with a URL. In a future lesson, we will use a form that specifies a PATCH action to reach this route."
end

delete('/albums/:id') do
  @album = Album.find(params[:id].to_i()) #update code pg24
  @album.delete()
  @albums = Album.all
  erb(:albums)
  # "This route will delete an album. We can't reach it with a URL. In a future lesson, we will use a delete button that specifies a DELETE action to reach this route."
end

# get('/custom_route') do
#   "We can even create custom routes, but we should only do this when needed."
# end

# Get the detail for a specific song such as lyrics and songwriters.
get('/albums/:id/songs/:song_id') do
  @song = Song.find(params[:song_id].to_i())
  erb(:song)
end

# Post a new song. After the song is added, Sinatra will route to the view for the album the song belongs to.
post('/albums/:id/songs') do
  @album = Album.find(params[:id].to_i())
  song = Song.new({:name => params[:song_name],:album_id => @album.id,:id => nil})
  song.save()
  erb(:album)
end

# Edit a song and then route back to the album view.
patch('/albums/:id/songs/:song_id') do
  @album = Album.find(params[:id].to_i())
  song = Song.find(params[:song_id].to_i())
  song.update(params[:name], @album.id)
  erb(:album)
end

# Delete a song and then route back to the album view.
delete('/albums/:id/songs/:song_id') do
  song = Song.find(params[:song_id].to_i())
  song.delete
  @album = Album.find(params[:id].to_i())
  erb(:album)
end


