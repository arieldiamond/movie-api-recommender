require 'rails_helper'

# RSpec.describe Movie, type: :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end
describe Movie, type: :model do
  let(:movie) { create(:movie) }

  # Validations
  xit { expect(movie).to validate_presence_of(:title) }
  xit { expect(movie).to validate_presence_of(:tmdb_id) }
  xit { expect(movie).to validate_uniqueness_of(:tmdb_id) }

  # Associations
  it "has many Roles" do
    m = Movie.reflect_on_association(:roles)
    expect(m.macro).to eq(:has_many)
  end
  it "has many People" do
    m = Movie.reflect_on_association(:people)
    expect(m.macro).to eq(:has_many)
  end

  # Factory is valid
  it "has a valid movie factory" do
    expect(FactoryGirl.build(:movie)).to be_valid
  end

  # Units
  describe '.score_genre' do
    it 'returns 0 when genres is nil' do
      expect(movie.score_genre(nil)).to eq(0)
    end
  end

  describe '.score_years' do
    it 'returns 0 when years is nil' do
      expect(movie.score_years(nil,nil)).to eq(0)
    end
  end

  describe '.score_crew' do
    it 'returns 0 when crew is nil' do
      expect(movie.score_crew(nil)).to eq(0)
    end
  end

  describe '.score_cast' do
    it 'returns 0 when cast is nil' do
      expect(movie.score_cast(nil)).to eq(0)
    end
  end

  describe '.score_rating' do
    it 'returns 0 when rating is nil' do
      expect(movie.score_rating(nil)).to eq(0)
    end
  end

  describe '#insert_movies' do
    it '' do
      expect(described_class.insert_movies(nil)).to eq([])
    end
  end
end