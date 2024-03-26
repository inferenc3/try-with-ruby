# Check Ruby LSP is running.

class RowCreator
  MEASUREMENTS_PER_CITY = 10
  MINIMUM_ROWS = 1000

  def initialize(num_rows, station_names_and_min_max_means)
    @num_rows = num_rows
    @station_names_and_min_max_means = station_names_and_min_max_means
  end

  # minimum rows 1000
  # measurements per city: 10
  # choose a random city until num_rows / 10
  # generate a random value
  # append to file with city and value
  def generate
    station_names_and_value_sequences = @station_names_and_min_max_means.transform_values do |min, max, mean|
      Helpers.values_with_min_max_mean(min, max, mean, num_measurements_per_station)
    end

    Helpers.drain_sequences_at_random(station_names_and_value_sequences) do |station_name, value|
      yield "#{station_name};#{value}"
    end
  end

  def write_measurements_to_file(path:, progress_indicator: false)
    raise "At least 1000 rows required" if @num_rows < 1000

    counter = 0

    File.open(path, "w") do |file|
      generate do |row|
        file.puts row

        if counter % (@num_rows / 100) == 0 && progress_indicator
          percent = ((counter.to_f / @num_rows) * 100).round
          print "\r#{percent}%".ljust(7)
          print '[' + ("█" * percent.to_i).ljust(100, '░') + ']'
        end

        counter = counter + 1
      end
    end

    print "\r100%".ljust(7) if progress_indicator
    print '[' + ("█" * 100) + ']'
  end

  def unpack_measurements_file(path)
    rows = File.read(path).split("\n").map! { |r| r.split(";") }

    reconstructed_spec = {}

    for row in rows
      station_name, value = row
      reconstructed_spec[station_name] ||= []
      reconstructed_spec[station_name] << value.to_f
    end

    for station, values in reconstructed_spec
      reconstructed_spec[station] = [values.min, values.max, values.sum.to_f / values.length] 
    end
  end
end

class Helpers
  class << self
    def write_lines_to_file(path, lines)
      File.open(path, "a") do |file|
        for line in lines
          file.puts line
        end
      end
    end

    def values_with_min_max_mean(min, max, mean, num_values)
      # Check if the specified min and max allow for the desired mean
      if mean < min || mean > max
        raise ArgumentError, "Mean is outside the range [min, max]"
      end

      if num_values < 3
        raise ArgumentError, "Not enough rows"
      end

      # Calculate the step required to distribute values to achieve the mean
      total_range = max - min
      adjustment = mean - min - (total_range.to_f / 2)
      step = total_range.to_f / (num_values - 1)

      # Generate the series of values
      series = Array.new(num_values) { |i| min + i * step + adjustment }

      series.map { |n| n.round(1) }
    end

    def drain_sequences_at_random(hash)
      # choose a random key from the hash
      # remove the first element from the array
      # if the array is empty, remove the key from the hash
      # return the key and the removed element
      while hash.any?
        key = hash.keys.sample
        value = hash[key].shift
        hash.delete(key) if hash[key].empty?
        yield [key, value]
      end
    end 

    def generate_spec_file_from_station_names(input_path, output_path)
      number_range = -100.0..100.0

      output_file = File.open(output_path, "w")
      File.readlines(input_path).each do |station_name|
        min, max = [rand(number_range).round(1), rand(number_range).round(1)].sort
        mean = rand(min..max).round(1)

        output_file.puts "#{station_name.strip};#{min.to_f};#{max.to_f};#{mean.to_f}"
      end
    end

    def unpack_spec_file(path)
      spec = {}

      File.readlines(path).map do |line|
        station_name, min, max, mean = line.split(";")
        spec[station_name] = [min.to_f, max.to_f, mean.to_f]
      end

      spec
    end
  end
end

H = Helpers
