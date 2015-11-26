require 'rails_helper'

RSpec.describe Rook do
  it 'has type of Rook' do
    expect(subject.type).to eq 'Rook'
  end

  describe '#valid_move?' do
    let(:rook) { create(:rook, position_x: 1, position_y: 8)}

    it "return true when valid move" do

    end

    it "return false when invalid move" do

    end
  end
end
