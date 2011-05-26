#!/usr/bin/env ruby
#coding: utf-8

class Screening < ActiveRecord::Base
  def self.get_percent_filling_by_movie_id(movieID)
    #Screening.order("time_before_screening").find_all_by_movie_id(movieID)
    find_by_sql(["select floor(time_before_screening/1) as tbs, avg(seats_taken/seats_total) as obsadenost from screenings where movie_id = ? group by tbs", movieID])
  end
end
