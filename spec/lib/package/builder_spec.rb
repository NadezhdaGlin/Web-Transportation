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
          expect(information).to include(weight: 32.4, length: 5, width: 12, height: 3, distance: 1356.8,
                                         price: 4070)
        end
      end
    end

    context 'When data is not entered' do
      let(:params) do
        { weight: 32.4, length: '', width: 12, height: 3, origins: 'Krasnodar', destinations: 'Moscow' }
      end
      it 'return raise error' do
        expect { information }.to raise_error('Space is not a value')
      end
    end

    context 'When specifying one city' do
      let(:params) do
        { weight: 32.4, length: 5, width: 12, height: 3, origins: 'Krasnodar', destinations: '' }
      end
      it 'return raise error' do
        expect { information }.to raise_error('Space is not a value')
      end
    end

    context 'When specifying two identical cities' do
      let(:params) do
        { weight: 32.4, length: 5, width: 12, height: 3, origins: 'Krasnodar', destinations: 'Krasnodar' }
      end
      it 'return raise error' do
        expect { information }.to raise_error("You can't enter two identical values")
      end
    end

    context 'When incorrect values' do
      let(:params) do
        { weight: -1, length: 0, width: 12, height: 0, origins: 'Krasnodar', destinations: 'Moscow' }
      end
      it 'return raise error' do
        VCR.use_cassette('Krasnodar_Moscow') do
          expect { information }.to raise_error('Values cannot be negative')
        end
      end
    end

    context 'Price when cargo <= 1 cub meter' do
      let(:params) do
        { weight: 9.5, length: 1, width: 1, height: 1, origins: 'Krasnodar', destinations: 'Moscow' }
      end
      it 'returned price' do
        VCR.use_cassette('Krasnodar_Moscow') do
          expect(information).to include(weight: 9.5, length: 1, width: 1, height: 1, distance: 1356.8,
                                         price: 1357)
        end
      end
    end

    context 'Price when cargo > 1 cub meter && weight < 10' do
      let(:params) do
        { weight: 9.5, length: 2, width: 3, height: 4, origins: 'Krasnodar', destinations: 'Moscow' }
      end
      it 'returned price' do
        VCR.use_cassette('Krasnodar_Moscow') do
          expect(information).to include(weight: 9.5, length: 2, width: 3, height: 4, distance: 1356.8,
                                         price: 1357)
        end
      end
    end

    context 'Price when cargo > 1 cub meter && weight > 10' do
      let(:params) do
        { weight: 32.4, length: 5, width: 12, height: 3, origins: 'Krasnodar', destinations: 'Moscow' }
      end
      it 'returned price' do
        VCR.use_cassette('Krasnodar_Moscow') do
          expect(information).to include(weight: 32.4, length: 5, width: 12, height: 3, distance: 1356.8,
                                         price: 4070)
        end
      end
    end
  end
end
