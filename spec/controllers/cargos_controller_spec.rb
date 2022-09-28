# frozen_string_literal: true

require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe CargosController, type: :controller do
  let!(:user) { create :user }
  let(:cargo) { create :cargo }

  let!(:cargo1) { create :cargo, user_id: user.id }
  let!(:cargo2) { create :cargo, user_id: user.id, price: 2643 }

  let!(:org) { create :organization }
  let!(:user_orgadmin) { create :user, organization_id: org.id }
  let!(:user_operator) { create :user, role: 'operator', organization_id: org.id }
  let!(:cargo_org1) { create :cargo, user_id: user_operator.id }
  let(:cargo_org2) { create :cargo, user_id: user_orgadmin.id }

  let(:another_org) { create :organization, name_org: 'BlahBlah' }
  let(:user_another_org) { create :user, role: 'operator', organization_id: another_org.id }

  context '#index' do
    subject(:index) { get :index }

    context 'when user orgadmin' do
      before { sign_in user_orgadmin }
      it 'returns all org cargos if user is org admin' do
        index
        expect(assigns(:cargos)).to match_array([cargo_org1, cargo_org2])
      end

      it 'returns a specific user cargos' do
        index
        expect(assigns(:cargos)).to match_array([cargo_org1])
      end
    end

    context 'when user operator' do
      before { sign_in user_operator }
      it 'returns all org cargos if user is operator' do
        index
        expect(assigns(:cargos)).to match_array([cargo_org1])
      end
    end

    context 'when user authorized' do
      before { sign_in user }
      subject(:index_sort) { get :index, params: { sort: 'price', direction: 'desc' } }

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
    subject(:show) { get :show, params: { id: cargo_org1.id } }

    context 'when user orgadmin or operator' do
      before { sign_in user_orgadmin || user_operator }

      it 'returns cargo' do
        show
        expect(assigns(:cargo)).to eq(Cargo.last)
      end

      it 'returns status 200' do
        show
        expect(show).to have_http_status(200)
      end
    end

    context 'when user operator wants to see other cargos of the organization' do
      subject(:show) { get :show, params: { id: cargo_org2.id } }
      before { sign_in user_operator }

      it 'redirect back' do
        expect(show).to have_http_status(302)
      end
    end

    context 'when user of another organization wants to see the cargo of another organization' do
      subject(:show) { get :show, params: { id: cargo_org1.id } }

      before { sign_in user_another_org }

      it 'redirect back' do
        expect(show).to have_http_status(302)
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
      before { sign_in user_orgadmin || user_operator }

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

    context 'when user doesnt have role and organization' do
      let!(:user) { create :user, role: nil, organization_id: nil }
      before { sign_in user }

      it 'redirect back' do
        VCR.use_cassette('Cargo_controller') do
          expect(create_cargo).to have_http_status(302)
        end
      end

      it 'return nothing' do
        VCR.use_cassette('Cargo_controller') do
          expect { create_cargo }.to change(Cargo, :count).by(0)
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

  context '#update' do
    let(:params) do
      { name: 'Rebecca',
        surname: 'Gros',
        middle_name: 'Wind',
        phone: '12345678910',
        email: 'juli@gmail.com',
        weight: 9.5, length: 2, width: 3, height: 4,
        origins: 'Anapa',
        destinations: 'Moscow',
        distance: 1528.5,
        price: 1529,
        cargo: cargo }
    end

    let(:update_params) { { id: cargo.id, cargo: params } }
    subject(:update) { patch :update, params: update_params }

    context 'when user orgadmin or operator' do
      let!(:cargo) { create :cargo, user_id: user_operator.id }
      before { sign_in user_orgadmin || user_operator }

      it 'returns updated cargo organization' do
        VCR.use_cassette('Interaction_cargo_Anapa-Moscow') do
          update
          expect(cargo.reload.name).to eq('Rebecca')
        end
      end
    end

    context 'when user operator trying to update someone elses records' do
      let!(:cargo) { create :cargo, user_id: user_orgadmin.id }
      before { sign_in user_operator }

      it 'redirect back when user operator' do
        VCR.use_cassette('Interaction_cargo_Anapa-Moscow') do
          expect(update).to have_http_status(302)
        end
      end
    end

    context 'when user of another organization wants to updating the cargo of another organization' do
      subject(:cargo) { create :cargo, user_id: user_operator.id }
      before { sign_in user_another_org }

      it 'redirect back' do
        expect(update).to have_http_status(302)
      end
    end
  end
end
