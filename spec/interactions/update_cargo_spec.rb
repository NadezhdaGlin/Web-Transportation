# frozen_string_literal: true

require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe Cargos::UpdateCargo, type: :interaction do
  context '#update' do
    let!(:user) { create :user }
    let!(:cargo) { create :cargo }
    subject(:update_cargo) { described_class.run(params) }

    context 'valid params' do
      let(:params) do
        { name: 'Rebeca',
          surname: 'Gros',
          middle_name: 'Wind',
          phone: '12345678910',
          email: 'juli@gmail.com',
          weight: 9.5, length: 2, width: 3, height: 4,
          origins: 'Anapa',
          destinations: 'Moscow',
          distance: 1528.5,
          price: 1529,
          cargo: cargo,
          user: user }
      end

      it 'returns updated user params cargo' do
        VCR.use_cassette('Interaction_cargo_Anapa-Moscow') do
          update_cargo
          cargo.reload
          expect(cargo.name).to eq('Rebeca')
          expect(update_cargo.valid?).to eq(true)
        end
      end

      it 'returns updated params cargo' do
        VCR.use_cassette('New_params_for_cargo') do
          update_cargo
          cargo.reload
          expect(cargo.origins).to eq('Anapa')
          expect(cargo.distance).to eq(1528.5)
          expect(cargo.price).to eq(1529)
          expect(update_cargo.valid?).to be(true)
        end
      end
    end

    context 'invalid params' do
      let(:params) do
        { name: 'Rebeca',
          surname: 'Gros',
          middle_name: 'Wind',
          phone: '12345678910',
          email: 'juli@gmail.com',
          weight: -10, length: 2, width: 3, height: 4,
          origins: 'Anapa',
          destinations: 'Moscow',
          distance: 1528.5,
          price: 1529,
          cargo: cargo,
          user: user }
      end

      it 'returns not updated' do
        VCR.use_cassette('Invalid_cargo_params_interaction1') do
          expect { update_cargo }.to raise_error(RuntimeError)
        end
      end
    end
  end
end
