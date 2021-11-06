require "#{File.dirname(__FILE__)}/../../lib/polar/lib/polar_data_parser"

class TrainingController < ApplicationController
  def details
    date = params[:date]
    time = params[:time]

    date_is_valid = /^\d{8}$/ =~ date
    time_is_valid = /^\d{6}$/ =~ time

    if !date_is_valid || !time_is_valid
      render status: :bad_request
      return false
    end

    @directory = "#{File.dirname(__FILE__)}/../../../synch/U/0/#{date}/E/#{time}"

    if !Dir.exists?(@directory)
      render status: :not_found
      return false
    end

    parsed = PolarDataParser.parse_training_session(@directory)

    @sport = parsed[:sport]
    @training_session = parsed[:training_session]
    @sensors = parsed[:sensors]
    @samples = parsed[:samples]
    @route_samples = parsed[:route_samples]
    @swimming_samples = parsed[:swimming_samples]
    @laps = parsed[:exercise_laps]
  end
end
