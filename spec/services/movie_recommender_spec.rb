require 'rails_helper'

describe MovieRecommender, type: :class do
  let(:movie) { create(:movie) }
  let(:recommender) { MovieRecommender.new}
  let(:preferences) {{:start_year=>1999, :end_year=>1999, :genres=>[18], :cert=>["R"], :crew=>[7467, 7474, 7475, 1254, 376, 7469], :actors=>[819, 287, 1283, 7470, 7499]}}

  describe '.recommended_movies' do
    xit 'returns 0 when genres is nil' do
      expect(recommender.recommended_movies(preferences)).to eq(Array)
    end
  end
end