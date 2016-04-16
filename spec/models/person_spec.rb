require 'rails_helper'

RSpec.describe Person, type: :model do
  let(:person) { create(:person) }

  # Validations
  xit { expect(person).to validate_presence_of(:name) }
  xit { expect(person).to validate_presence_of(:tmdb_id) }
  xit { expect(person).to validate_uniqueness_of(:tmdb_id) }

  # Associations
  it "has many Movies" do
    p = Person.reflect_on_association(:movies)
    expect(p.macro).to eq(:has_many)
  end
  it "has many Roles" do
    p = Person.reflect_on_association(:roles)
    expect(p.macro).to eq(:has_many)
  end
end