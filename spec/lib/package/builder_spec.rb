# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Package::Builder do
  describe '.cargo_information' do
    subject(:information) { described_class.cargo_information(params) }

    context 'Response with entered information' do
      let(:params) do
        { weight: 32.4, length: 5, width: 12, height: 3, origins: 'Krasnodar', destinations: 'Moscow' }
      end
      it 'return hash' do
        VCR.use_cassette('Krasnodar_Moscow') do
          expect(information).to include(weight: 32.4, length: 5, width: 12, height: 3, distance: 1351.0,
                                         price: 4053)
        end
      end
    end

    context 'when data is not entered' do
      let(:params) do
        { weight: 32.4, length: '', width: 12, height: 3, origins: 'Krasnodar', destinations: 'Moscow' }
      end
      it 'return raise error' do
        VCR.use_cassette('empty_value_Krasnodar_Moscow') do
          expect { information }.to raise_error('Space is not a value')
        end
      end
    end
  end

  describe '.routs' do
    context 'When specifying one city' do
      subject(:routes) { described_class.routs('Krasnodar', '') }
      it 'return raise error' do
        expect { routes }.to raise_error('Origins or Destinations is empty')
      end
    end

    context 'When specifying two identical cities' do
      subject(:routes) { described_class.routs('Krasnodar', 'Krasnodar') }
      it 'return raise error' do
        expect { routes }.to raise_error("You can't enter two identical values")
      end
    end
  end

  describe '.distance' do
    context 'Getting the distance between two cities' do
      subject(:distance) { described_class.distance('Krasnodar', 'Moscow') }
      it 'return distance value' do
        VCR.use_cassette('Krasnodar_Moscow') do
          expect(distance).to eq(1351.0)
        end
      end
    end
  end

  describe '.distance_length' do
    context 'Getting the distance between two cities' do
      subject(:distance) { described_class.distance('Krasnodar', 'Moscow') }
      it 'return distance value' do
        VCR.use_cassette('Krasnodar_Moscow') do
          expect(distance).to eq(1351.0)
        end
      end
    end
  end

  describe '.price' do
    subject(:distance) { described_class.distance('Krasnodar', 'Moscow') }
    context 'Price when cargo <= 1 cub meter' do
      let(:params1) { { weight: 9.5, length: 1, width: 1, height: 1 } }
      subject(:price1) { described_class.price(params1, distance) }
      it 'returned price' do
        VCR.use_cassette('Krasnodar_Moscow') do
          expect(price1).to eq(1351)
        end
      end
    end
    context 'Price when cargo > 1 cub meter && weight < 10' do
      let(:params2) { { weight: 9.5, length: 2, width: 3, height: 4 } }
      subject(:price2) { described_class.price(params2, distance) }
      it 'returned price' do
        VCR.use_cassette('Krasnodar_Moscow') do
          expect(price2).to eq(1351)
        end
      end
    end
    context 'Price when cargo > 1 cub meter && weight > 10' do
      let(:params3) { { weight: 32.4, length: 5, width: 12, height: 3 } }
      subject(:price3) { described_class.price(params3, distance) }
      it 'returned price' do
        VCR.use_cassette('Krasnodar_Moscow') do
          expect(price3).to eq(4053)
        end
      end
    end
    context 'When incorrect values' do
      let(:wrong_params) { { weight: -1, length: 0, width: 12, height: 0 } }
      subject(:negative_value) { described_class.price(wrong_params, distance) }
      it 'return raise error' do
        VCR.use_cassette('Krasnodar_Moscow') do
          expect { negative_value }.to raise_error('Values cannot be negative')
        end
      end
    end
  end
end
