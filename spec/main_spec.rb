require "./spec_helper.rb"
require "./main.rb"

RSpec.describe RowCreator do
  let(:num_rows) { 3 }

  let(:station_names_and_values) do
    [
      ["station1", "1"],
      ["station2", "2"],
      ["station3", "3"],
    ]
  end

  let(:instance) { described_class.new(num_rows, station_names_and_values) }

  it "generates rows" do
    limit = 15
    counter = 0

    instance.generate do |row|
      parsed_row = row.split(";")

      expect(parsed_row).to eq station_names_and_values[counter % 3]

      counter = counter + 1
      break if counter == limit
    end
  end

  it "generates a finite sequence" do
    limit = 15
    counter = 0

    instance.generate_finite_sequence(9) do |row|
      parsed_row = row.split(";")

      counter = counter + 1
      break if counter == limit
    end

    expect(counter).to eq 9
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

  fcontext "#values_with_min_max_mean" do
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
end
