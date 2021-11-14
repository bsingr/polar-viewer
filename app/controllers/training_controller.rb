require "#{File.dirname(__FILE__)}/../../lib/polar/lib/polar_data_parser"

class TrainingController < ApplicationController
  def get_directory()
    return "#{File.dirname(__FILE__)}/../../synch/U/0"
  end

  def get_date_directory(date)
    return "#{self.get_directory()}/#{date}/E"
  end

  def get_time_directory(date, time)
    return "#{self.get_date_directory(date)}/#{time}"
  end

  def is_valid_date(date)
    return /^\d{8}$/ =~ date
  end

  def is_valid_time(time)
    return /^\d{6}$/ =~ time
  end

  def list_dates
    directory = self.get_directory()
    if !Dir.exists?(directory)
      render status: :not_found
      return false
    end

    entries = Dir.entries(directory)
    @dates = entries.select {|entry| self.is_valid_date(entry) }.sort
  end

  def list_times
    @date = params[:date]

    directory = self.get_date_directory(@date)
    if !Dir.exists?(directory)
      render status: :not_found
      return false
    end

    entries = Dir.entries(directory)
    @times = entries.select {|entry| self.is_valid_time(entry) }.sort
  end

  def details
    @date = params[:date]
    time = params[:time]

    date_is_valid = /^\d{8}$/ =~ @date
    time_is_valid = /^\d{6}$/ =~ time

    if !date_is_valid || !time_is_valid
      render status: :bad_request
      return false
    end

    directory = self.get_time_directory(@date, time)

    if !Dir.exists?(directory)
      render status: :not_found
      return false
    end

    parsed = PolarDataParser.parse_training_session(directory)

    @sport = parsed[:sport]
    @training_session = parsed[:training_session]
    @sensors = parsed[:sensors]
    @samples = parsed[:samples]
    @route_samples = parsed[:route_samples]
    @swimming_samples = parsed[:swimming_samples]
    @laps = parsed[:exercise_laps]

    recording_interval = @samples.recording_interval.hours * 3600 + @samples.recording_interval.minutes * 60 + @samples.recording_interval.seconds + (@samples.recording_interval.millis.to_f / 1000)
    samples_count = @samples.speed_samples.count
    chart_data = Array.new
    timestamp = Time.at(0).utc
    for i in 0..samples_count-1
      timestamp += recording_interval

      heart_rate = 1
      distance = 0
      pace = 1

      if @samples.heart_rate_samples[i]
        heart_rate = @samples.heart_rate_samples[i]
      end
      if @samples.distance_samples[i]
        distance = "%7.1f" % @samples.distance_samples[i]
      end
      if @samples.speed_samples[i]
        pace = @samples.speed_samples[i]
      end

      chart_data.append({
        time: timestamp.strftime("%H:%M:%S"),
        heart_rate: heart_rate,
        distance: distance,
        pace: pace
      })

      #r = []
      #r << timestamp.strftime("%H:%M:%S")
      #r << "#{"%7.1f" % samples.distance_samples[i]} m" if samples.distance_samples[i]
      #r << "#{"%3.2f" % (60.0 / samples.speed_samples[i])} min/km" if samples.speed_samples[i]
      #r << "HR=#{"%3.0f" % samples.heart_rate_samples[i]} bpm" if samples.heart_rate_samples[i]
      #r << "alt=#{"%4.1f" % samples.altitude_samples[i]}#{" (corrected=#{"%4.1f" % (samples.altitude_samples[i] + altitude_delta)})" if altitude_delta != 0} m" if samples.altitude_samples[i]
      #r << "temp=#{"%2.1f" % samples.temperature_samples[i]} °C" if samples.temperature_samples[i]
      #r << "cadence=#{samples.cadence_samples[i]}" if samples.cadence_samples[i]
      #r << "stride length=#{samples.stride_length_samples[i]}" if samples.stride_length_samples[i]
      #r << "left power=#{samples.left_pedal_power_samples[i].current_power}" if samples.left_pedal_power_samples[i]
      #r << "right power=#{samples.right_pedal_power_samples[i].current_power}" if samples.right_pedal_power_samples[i]
      #r << "forward acceleration=#{samples.forward_acceleration[i]}" if samples.forward_acceleration[i]
      #r << "moving type=#{samples.moving_type_samples[i]}" if samples.moving_type_samples[i]
    end

    gps_track_positions = Array.new

    route_samples_count = @route_samples.latitude.count
    if route_samples_count > 0
      for i in 0..route_samples_count-1
        gps_track_positions.append([
          @route_samples.latitude[i],
          @route_samples.longitude[i]
        ])
      end
    end

    @chart_data = chart_data
    @gps_track_positions = gps_track_positions
  end
end
