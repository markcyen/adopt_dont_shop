require 'rails_helper'

RSpec.describe 'the admin shelters index' do
  it 'lists all the shelter names in reverse alphabetical' do
    shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
    mr_pirate = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    clawdia = shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    lucy_bald = shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    ricky_ricardo = shelter_3.pets.create(name: 'Ricky Ricardo', breed: 'aussie', age: 4, adoptable: true)

    visit '/admin/shelters'

    within("#list_of_shelters") do
      expect(shelter_3.name).to appear_before(shelter_1.name)
    end
  end

  it 'shows shelters with pending applications' do
    shelter_4 = Shelter.create(name: 'Coloradog shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    shelter_5 = Shelter.create(name: 'TSP animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    shelter_6 = Shelter.create(name: 'Crazy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
    mr_pirate = shelter_4.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    clawdia = shelter_4.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    lucy_bald = shelter_6.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    ricky_ricardo = shelter_6.pets.create(name: 'Ricky Ricardo', breed: 'aussie', age: 4, adoptable: true)

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
      status: 'In Progress'
    )

    @tkt_application.pets << lucy_bald

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

    @jms_application.pets << mr_pirate
    @jms_application.pets << clawdia

    visit '/admin/shelters'

    within("#shelters_with_pending_apps") do
      expect(page).to have_content(shelter_4.name)
      expect(page).to_not have_content(shelter_5.name)
      expect(page).to_not have_content(shelter_6.name)
    end
  end
end
