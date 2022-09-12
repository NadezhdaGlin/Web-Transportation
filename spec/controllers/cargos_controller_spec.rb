# frozen_string_literal: true

require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe CargosController, type: :controller do
  let!(:user) { create :user }
  let(:cargo) { create :cargo }

  let!(:cargo1) { create :cargo, user_id: user.id }
  let!(:cargo2) { create :cargo, user_id: user.id, price: 2643 }

  context '#index' do
    subject(:index) { get :index }

    context 'when user authorized' do
      before { sign_in user }
      subject(:index_sort) { get :index, params: { sort: 'price', direction: 'desc' } }

      it 'returns all information' do
        index
        expect(assigns(:cargos)).to match_array([cargo1, cargo2])
      end

      it 'return sorted information by price' do
        index_sort
        expect(assigns(:cargos)).to eq(user.cargos.order(price: :desc))
      end

      it 'returns status 200' do
        expect(index).to have_http_status(200)
      end

      context 'when paginate' do
        subject(:index_paginate) { get :index, params: { page: '2' } }
        let!(:cargo_list) { create_list :cargo, 5, user_id: user.id }
        it 'return paginated cargos' do
          index_paginate
          expect(assigns(:cargos).count).to eq(2)
        end
      end
    end

    context 'when user unauthorized' do
      before { sign_out user }

      it 'return nothing' do
        index
        expect(assigns(:cargos)).to eq(nil)
      end

      it 'redirects to the login page' do
        expect(index).to redirect_to(new_user_session_path)
      end

      it 'return status 302' do
        expect(index).to have_http_status(302)
      end
    end
  end

  context '#show' do
    subject(:show) { get :show, params: { id: Cargo.last.id } }

    context 'when user authorized' do
      before { sign_in user }

      it 'returns cargo' do
        show
        expect(assigns(:cargo)).to eq(Cargo.last)
      end

      it 'returns status 200' do
        show
        expect(show).to have_http_status(200)
      end
    end

    context 'when user unauthorized' do
      before { sign_out user }

      it 'return nothing' do
        show
        expect(assigns(:cargo)).to eq(nil)
      end

      it 'redirects to the login page' do
        expect(show).to redirect_to(new_user_session_path)
      end

      it 'return status 302' do
        expect(show).to have_http_status(302)
      end
    end
  end

  context '#create' do
    let!(:cargo_values) { attributes_for :cargo }
    subject(:create_cargo) { post :create, params: { cargo: cargo_values } }

    context 'when user authorized' do
      before { sign_in user }

      it 'return creates cargo' do
        VCR.use_cassette('Cargo_controller') do
          expect { create_cargo }.to change(Cargo, :count).by(1)
        end
      end

      it 'return cargo page' do
        VCR.use_cassette('Cargo_controller') do
          expect(create_cargo).to redirect_to(cargo_path(Cargo.last))
        end
      end

      it 'return status 302' do
        VCR.use_cassette('Cargo_controller') do
          expect(create_cargo).to have_http_status(302)
        end
      end
    end

    context 'when user unauthorized' do
      before { sign_out user }

      it 'return nothing' do
        VCR.use_cassette('Cargo_controller') do
          expect { create_cargo }.to change(Cargo, :count).by(0)
        end
      end

      it 'redirects to the login page' do
        expect(create_cargo).to redirect_to(new_user_session_path)
      end

      it 'return status 302' do
        expect(create_cargo).to have_http_status(302)
      end
    end
  end
end
