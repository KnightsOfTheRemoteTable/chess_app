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
end
