# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :cargos, dependent: :destroy
  belongs_to :organization, optional: true

  def is_operator?
    role == 'operator'
  end

  def is_organization_admin?
    role == 'orgadmin'
  end
end
