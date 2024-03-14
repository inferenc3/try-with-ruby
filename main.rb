# Check Ruby LSP is running.

class RowCreator
  def initialize(num_rows, station_names_and_min_max_means)
    @num_rows = num_rows
    @station_names_and_min_max_means = station_names_and_min_max_means
  end

  def generate
    @station_names_and_min_max_means.cycle.map do |station_name, value|
      yield "#{station_name};#{value}"
    end
  end

  def generate_finite_sequence(limit)
    counter = 0

    generate do |row|
      yield row
      counter = counter + 1
      break if counter == limit
    end
  end

  def dump(path)
    File.open(path, "a") do |file|
      file.puts "This is the line I want to append."
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
  end
end

H = Helpers
