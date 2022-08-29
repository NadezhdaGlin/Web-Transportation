# frozen_string_literal: true

require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe CargosController, type: :controller do
  let!(:user) { create :user }
  let(:cargo) { create :cargo }

  let!(:cargo1) { create :cargo, user_id: user.id }
  let!(:cargo2) { create :cargo, user_id: user.id, price: 2643 }

  context '#index' do

    context 'when user authorized' do
      before { sign_in user }
      subject(:index) { get :index }

      subject(:index_sort) { get :index, params: {sort: "price", sort_direction: 'desc'}}

      it 'returns all information' do
        index
        expect(assigns(:cargos)).to match_array([cargo1, cargo2])
      end

      it 'return sorted information by price' do
        index_sort
        expect(assigns(:cargos)).to eq(Cargo.all.order(price: :desc))
      end

      it 'returns status' do
        expect(index).to have_http_status(200)
    end
  end

    context 'when user unauthorized' do

    end
  end

  context '#show' do

    context 'when user authorized' do
      before { sign_in user }
      subject(:show) { get :show, params: { id: Cargo.last.id } }

      it 'returns cargo' do
        show
        expect(assigns(:cargo)).to eq(Cargo.last)
      end
      
      it 'returns status' do
        show
        expect(show).to have_http_status(200)
      end
    end

    context 'when user unauthorized' do

    end
  end

  context '#create' do

    context 'when user authorized' do
      before { sign_in user }
      let!(:cargo_values) { attributes_for :cargo }
      subject(:create_cargo) { post :create, params: { cargo: cargo_values } }

      it 'return created cargo' do
        VCR.use_cassette('Cargo_controller') do
          expect { create_cargo }.to change(Cargo, :count).by(1)
        end
      end
      it 'return cargo page' do
        VCR.use_cassette('Cargo_controller') do
          expect(create_cargo).to redirect_to(cargo_path(Cargo.last))
        end
      end
      it 'return status' do
        VCR.use_cassette('Cargo_controller') do
          expect(create_cargo).to have_http_status(302)
        end
      end
    end

    context 'when user unauthorized' do

    end
  end
end
