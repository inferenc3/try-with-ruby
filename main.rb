# Check Ruby LSP is running.

class RowCreator
  def initialize(num_rows, station_names_and_min_max_means)
    @num_rows = num_rows
    @station_names_and_min_max_means = station_names_and_min_max_means
  end

  def generate
    station_names_and_value_sequences = Helpers.generate_value_sequences(@num_rows, @station_names_and_min_max_means)

    Helpers.drain_sequences_at_random(station_names_and_value_sequences) do |station_name, value|
      yield "#{station_name};#{value}"
    end
  end

  def write_measurements_to_file(path)
    File.open(path, "w") do |file|
      generate do |row|
        file.puts row 
      end
    end
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

      # Calculate the step required to distribute values to achieve the mean
      total_range = max - min
      adjustment = mean - min - (total_range.to_f / 2)
      step = total_range.to_f / (num_values - 1)

      # Generate the series of values
      series = Array.new(num_values) { |i| min + i * step + adjustment }

      series
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

    def generate_value_sequences(num_rows, station_names_and_min_max_means)
      num_measurements_per_station = (num_rows / station_names_and_min_max_means.size).round

      station_names_and_value_sequences = station_names_and_min_max_means.transform_values do |min, max, mean|
        values_with_min_max_mean(min, max, mean, num_measurements_per_station)
      end   
    end
  end
end

H = Helpers
