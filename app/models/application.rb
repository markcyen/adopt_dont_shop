class Application < ApplicationRecord
  has_many :application_pets
  has_many :pets, through: :application_pets
  validates :first_name, :last_name, presence: true
  validates :street_number, presence: true, numericality: true
  validates :street_name, :street_type, presence: true
  validates :city, :state, presence: true
  validates :zip_code, presence: true, numericality: true
  validates :description, presence: true
  before_save :default_status



  def default_status
    self.status = 'In Progress'
  end
end
