#!/usr/bin/env ruby
#coding: utf-8

class Movie < ActiveRecord::Base

  def self.get_movies_ordered_by_screening_count
    find_by_sql(["SELECT movies.id as id, movies.name, COUNT(screenings.id) as number_of_screenings FROM movies JOIN screenings ON movies.id = screenings.movie_id GROUP BY screenings.movie_id, movies.id ORDER BY number_of_screenings DESC"])
  end
  
  def self.schedule_downloads
      # zakladny priecinok kde sa nachadzaju vsetky disdata_XXXX_YYXXYY priecinky
      # basedir = "/Volumes/rackom-ICY/rubyOnRails_DATA"
      basedir = "/Users/michalracko/Downloads/DISDATA"

      # obsah priecinku
      dirs = Dir.new(basedir).entries
      
      dirs.each do |directory|
        next unless directory.include?('disdata')

        next_dir = Dir.new(basedir + "/" + directory).entries

        next_dir.each do |file|
          next unless file.include?('html')
          next unless file.include?('akce')
          html = open(basedir + "/" + directory + "/" + file).read
          doc = Nokogiri::HTML(html)

          Movie.parse_movie(doc)
          Movie.parse_content(doc, File.ctime(basedir + "/" + directory + "/" + file))
          end
      end
  end

  def self.get_movie_name_by_id(movieID)
    Movie.find_by_id(movieID).name
  end

  def self.name_starts_with(query)
    where(["name LIKE ?", "#{query}%"])
  end

  def self.parse_movie(doc)
    meno = doc.css(".infAkTx").first.content
    movie = Movie.find_or_initialize_by_name(meno)
    movie.name = meno
    movie.display_name = meno.capitalize
    movie.save
    movie
  end

  def self.parse_content(doc, date_created)
    # puts doc.css(".infAkTx")[1].content

    dv = doc.css(".infAkTx")[1].content
    # nejake opravy pre ceske casy a datumy†
    dv.gsub!("Po","Mon")
    dv.gsub!("Út","Thu")
    dv.gsub!("Ut","Thu")
    dv.gsub!("St","Wed")
    dv.gsub!("Čt","Thu")
    dv.gsub!("Št","Thu")
    dv.gsub!("Pá","Fri")
    dv.gsub!("Pi","Fri")
    dv.gsub!("So","Sat")
    dv.gsub!("Ne","Sun")
    dv.gsub!(". ","/")
    dv.gsub!(".","/")

    datum_vysielania = DateTime.strptime(dv, "%d/%m/%y %a %H:%M")
    datum_vytvorenia = DateTime.strptime(date_created.to_s, "%a %b %d %H:%M:%S +0200 %Y");

    rozdiel_dni = (datum_vysielania - datum_vytvorenia).to_i

    if rozdiel_dni < 3 and doc.css(".sRe").count > 0 and rozdiel_dni > 0
      screening = Screening.new
      screening.movie_id = Movie.find_by_name(doc.css(".infAkTx").first.content.upcase).id
      screening.time_before_screening = ((datum_vysielania - datum_vytvorenia) * 24)
      screening.seats_taken = doc.css(".sRe").count
      screening.seats_total = doc.css(".sRe").count + doc.css(".sV1").count
      screening.save
      screening
    end
  end
end
