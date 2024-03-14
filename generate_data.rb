require './main.rb'

spec = Helpers.unpack_spec_file('./spec.txt')
RowCreator.new(ARGV[0].to_i || 10_000_000, spec).write_measurements_to_file(path: './data.txt', progress_indicator: true)