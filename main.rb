# Check Ruby LSP is running.

class RowCreator
  def initialize(num_rows, station_names_and_averages)
    @num_rows = num_rows
    @station_names_and_averages = station_names_and_averages
  end

  def generate
    @station_names_and_averages.cycle.map do |station_name, average|
      yield "#{station_name};#{average}"
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
    File.open(path, 'a') do |file|
      file.puts "This is the line I want to append."
    end
  end
end

class Helpers
  class << self
    def write_lines_to_file(path, lines)
      File.open(path, 'a') do |file|
        for line in lines 
          file.puts line 
        end
      end       
    end
  end
end

H = Helpers
