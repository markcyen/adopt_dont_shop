require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'relationships' do
    it { should have_many(:application_pets).dependent(:destroy) }
    it { should have_many(:pets).through(:application_pets) }
  end

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:street_number) }
    it { should validate_numericality_of(:street_number) }
    it { should validate_presence_of(:street_name) }
    it { should validate_presence_of(:street_type) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip_code) }
  end

  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @mr_pirate = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    @clawdia = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @lucy_bald = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @ann = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)
  end

  describe 'class methods' do
    describe '#count' do
      it 'counts pets' do
        @amm_application = Application.create!(
          first_name: 'Amy',
          middle_name: 'Mary',
          last_name: 'Margi',
          street_number: 8399,
          street_name: 'Sally',
          street_type: 'Court',
          city: 'Arvada',
          state: 'CO',
          zip_code: '89429',
          status: 'In Progress'
        )
        @amm_application.pets << @lucy_bald
        @amm_application.pets << @clawdia
        @amm_application.pets << @ann

        expect(@amm_application.pet_count).to eq(3)
      end
    end

    describe '#search' do
      it 'returns partial matches' do
        expect(Pet.search("cLaw")).to eq([@clawdia])
        expect(Pet.search("pir")).to eq([@mr_pirate])
      end
    end

    describe '#pending' do
      it 'returns only shelters with pending applications' do
        @tkt_application = Application.create!(
          first_name: 'Timothy',
          middle_name: 'Kelly',
          last_name: 'Tyson',
          street_number: 8399,
          street_name: 'Thomas',
          street_type: 'Lane',
          city: 'Arvada',
          state: 'CO',
          zip_code: '89049',
          description: 'Love pets!',
          status: 'In Progress'
        )
        @tkt_application.pets << @lucy_bald
        @tkt_application.pets << @ann

        @jms_application = Application.create!(
          first_name: 'Jamie',
          middle_name: 'Marie',
          last_name: 'Sims',
          street_number: 8399,
          street_name: 'Thomas',
          street_type: 'Lane',
          city: 'Arvada',
          state: 'CO',
          zip_code: '89049',
          description: 'Pet owner for many years!',
          status: 'Pending'
        )
        @jms_application.pets << @mr_pirate
        @jms_application.pets << @clawdia

        expect(Application.pending[0].name).to eq(@shelter_1.name)
      end
    end
  end
end
