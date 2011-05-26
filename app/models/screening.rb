#!/usr/bin/env ruby
#coding: utf-8

class Screening < ActiveRecord::Base
  def self.get_percent_filling_by_movie_id(movieID)
    #Screening.order("time_before_screening").find_all_by_movie_id(movieID)
    find_by_sql(["select floor(time_before_screening/1) as time_before_screening, avg(seats_taken/seats_total) as obsadenost from screenings where movie_id = ? group by time_before_screening", movieID])
  end
end
