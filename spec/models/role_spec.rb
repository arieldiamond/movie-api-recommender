require 'rails_helper'

RSpec.describe Role, type: :model do
  let(:role) { create(:role) }

  # Validations
  xit { expect(role).to validate_presence_of(:person_id) }
  xit { expect(role).to validate_presence_of(:movie_id) }
  xit { expect(role).to validate_presence_of(:job) }

  # Associations
  it "belongs to Movie" do
    r = Role.reflect_on_association(:movie)
    expect(r.macro).to eq(:belongs_to)
  end
  it "belongs to Person" do
    r = Role.reflect_on_association(:person)
    expect(r.macro).to eq(:belongs_to)
  end
end
