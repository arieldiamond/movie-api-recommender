require 'rails_helper'

RSpec.describe Genre, type: :model do
  let(:genre) { build(:genre)}

  # Validations
  it { expect(genre).to validate_presence_of(:genre_id) }
  it { expect(genre).to validate_presence_of(:name) }

end
