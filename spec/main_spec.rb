require "./spec_helper.rb"
require "./main.rb"

RSpec.describe RowCreator do
  let(:num_rows) { 1000 }

  let(:station_names_and_values) do
    [
      ["station1", [-10, 20, 5]],
      ["station2", [0, 10, 5]],
      ["station3", [5, 15, 10]],
  ].to_h
  end

  let(:instance) { described_class.new(num_rows, station_names_and_values) }

  it "generates rows" do
    instance.generate do |row|
      name, value = row.split(";")

      expect(station_names_and_values.keys).to include(name)

      min, max, mean = station_names_and_values[name]
      expect(value.to_f).to be_between(min, max), "#{row} is not between #{min} and #{max}"
    end
  end

  fit "appends measurements to file" do
    path = "test_file_measurements.txt"

    File.delete(path) if File.exist?(path)

    instance.write_measurements_to_file(path: path)

    expect(File.read(path).split("\n").length).to eq(num_rows)

    for station_name, spec_values in instance.unpack_measurements_file(path)
      expect(spec_values).to eq(station_names_and_values[station_name])
    end
  end
end

RSpec.describe Helpers do
  context "#write_lines_to_file" do
    let(:path) { "test_file.txt" }

    before do
      File.delete(path) if File.exist?(path)
    end

    it "writes lines" do
      lines = ["line1", "line2", "line3"]

      described_class.write_lines_to_file(path, lines)

      expect(File.read(path)).to eq (lines.join("\n") + "\n")
    end
  end

  context "#values_with_min_max_mean" do
    let(:values) do
      described_class.values_with_min_max_mean(1, 3, 2, 5)
    end

    it 'produces values with correct min' do
      expect(values.min).to eq(1)
    end

    it 'produces values with correct max' do
      expect(values.max).to eq(3)
    end

    it 'produces values with correct mean' do
      expect(values.sum.to_f / values.length).to eq(2)
    end
  end

  context "#drain_sequences_at_random" do
    def deep_clone_hash_of_arrays(hash)
      hash.each_with_object({}) do |(key, value), cloned_hash|
        cloned_hash[key] = value.map(&:dup)
      end
    end

    let(:hash) do
      {
        "station1" => [1, 12, 3],
        "station2" => [4, 13, 6],
        "station3" => [7, 15, 9],
      }
    end

    it "drains sequences at random" do
      hash_copy = deep_clone_hash_of_arrays(hash)

      described_class.drain_sequences_at_random(hash_copy) do |key, value|
        expect(hash_copy[key]).not_to include(value) if hash_copy[key]
        expect(hash[key]).to include(value)
      end

      expect(hash_copy).to eq({})
    end

    context "#generate_spec_file_from_station_names" do
      it "generates spec file" do
        described_class.generate_spec_file_from_station_names('./cities.txt', './spec.txt')

        expect(described_class.unpack_spec_file('./spec.txt').keys.to_set).to eq(File.readlines('./cities.txt').map(&:strip).to_set)
      end
    end
  end
end
