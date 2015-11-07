require 'rails_helper'

RSpec.describe Game do
  it { is_expected.to have_attribute :name }

  it { is_expected.to belong_to :white_player }

  it { is_expected.to belong_to :black_player }

  it { is_expected.to have_many :chess_pieces }

  it { is_expected.to validate_presence_of :name }
end
