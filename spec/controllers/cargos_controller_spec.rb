# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CargosController, :type => :controller do
  
  let(:cargo){create :cargo}
  let!(:cargo1) {create :cargo}
  let!(:cargo2) {create :cargo}

  describe '#index' do
    subject(:index) {get :index}
    context 'Check cargos' do
       it 'returns all information' do
        index
        expect(assigns(:cargos)).to match_array([cargo1, cargo2])
       end 
    end

    context 'Status 200' do
      it "returns status" do
          expect(index).to have_http_status(200)
      end
    end
  end

  describe '#show' do
    subject(:show) {get :show, params: {id: Cargo.last.id}}
    context 'Check cargo' do
      it 'returns cargo' do
        show
        expect(assigns(:cargo)).to eq(Cargo.last)
      end
    end

    context 'Status 200' do
      it 'returns status' do
        show
        expect(show).to have_http_status(200)
      end
    end
  end

  describe '#create' do
    let!(:cargo_values) {attributes_for :cargo }
    subject(:create_cargo) {post :create, params: { cargo: cargo_values } }
    context 'create cargo' do
      it 'return created cargo' do
        VCR.use_cassette('Cargo_controller') do
          expect{create_cargo}.to change(Cargo, :count).by(1)
        end
      end
    end

    context 'redirect to cargo page' do
      it 'return cargo page' do
        VCR.use_cassette('Cargo_controller') do
          expect(create_cargo).to redirect_to(cargo_path(Cargo.last))
        end
      end
    end

    context 'Status 302' do
      it 'return status' do
        VCR.use_cassette('Cargo_controller') do
          expect(create_cargo).to have_http_status(302)
        end
      end
    end
  end
end
