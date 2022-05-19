require 'spec_helper'

describe '#Artist' do

  describe('.all') do
    it('returns an empty array when there are no artists') do
      expect(Artist.all).to(eq([]))
    end
  end

  describe('#save') do
    it('saves an artist') do
      artist = Artist.new({:name => "Ambeix", :id => nil}) # nil added as second argument
      artist.save()
      artist2 = Artist.new({:name => "Bathory", :id=> nil}) # nil added as second argument
      artist2.save()
      expect(Artist.all).to(eq([artist, artist2]))
    end
  end

  describe('#==') do
    it('is the same artist if it has the same attributes as another artist') do
      artist = Artist.new({:name => "Amebix", :id => nil})
      artist2 = Artist.new({:name => "Amebix", :id => nil})
      expect(artist).to(eq(artist2))
    end
  end
  
  describe('#update') do
    it('adds an album to an artist') do
      artist = Artist.new({:name => "John Coltrane", :id => nil})
      artist.save()
      album = Album.new({:name => "A Love Supreme", :id => nil})
      album.save()
      artist.update({:album_name => "A Love Supreme"})
      expect(artist.albums).to(eq([album]))
    end
  end
  
  describe('.find') do
    it('finds an artist by id') do
      artist = Artist.new({:name => "Amebix", :id => nil})
      artist.save()
      artist2 = Artist.new({:name => "Bathory", :id => nil})
      artist2.save()
      expect(Artist.find(artist.id)).to(eq(artist))
    end
  end

  describe('.clear') do
    it('clears all artists') do
      artist = Artist.new({:name => "Amebix", :id => nil})
      artist.save()
      artist2 = Artist.new({:name => "Bathory", :id => nil})
      artist2.save()
      Artist.clear()
      expect(Artist.all).to(eq([]))
    end
  end

  describe('#delete') do
    it('deletes an artist and all albums/songs') do
      artist = Artist.new({:name => "Amebix", :id => nil})
      artist.save()
      album = Album.new({:name => "Whos the Enemy", :id => nil})
      album.save()
      song = Song.new({:name => "Carnage", :album_id => album.id, :id => nil})
      song.save()
      artist.delete()
      expect(Artist.find(artist.id)).to(eq(nil))
    end
  end

  describe('.search') do
    it("searches for an artist by artist name") do
      artist = Artist.new({:name =>"Lil Porky",:id => nil})
      artist.save
      artist2 = Artist.new({:name =>"Love Supreme", :id => nil})
      artist2.save
      artist3 = Artist.new({:name =>'Giant Steps', :id => nil})
      artist3.save
      expect(Artist.search("por")).to(eq([artist]))  
    end
  end

  describe('#albums') do
    it('returns all albums related to an artist') do
      album = Album.new(:name => "This is a sweet album", :id => nil)
      album.save
      artist = Artist.new(:name => "Cool Artist Person", :id => nil)
      artist.save
      artist.update(:album_name => "This is a sweet album")
      expect(artist.albums).to(eq([album]))
    end
  end

end  


