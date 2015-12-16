require 'rails_helper'

RSpec.describe User do
  it { is_expected.to validate_presence_of :username }

  describe '#games' do
    it 'includes games played as white' do
      game = create(:game)

      expect(game.white_player.games).to include game
    end

    it 'includes games played as black' do
      game = create(:game)

      expect(game.black_player.games).to include game
    end
  end

  describe '#profile_data' do
    it 'returns a hash of relevant user data' do
      user = create(:user)
      registration_date = user.created_at.strftime('%m-%d-%Y')
      username = user.username
      wins_count = user.wins_count
      data = { name: username, playing_since: registration_date, total_wins: wins_count }
      expect(user.profile_data).to eq data
    end
  end
end
