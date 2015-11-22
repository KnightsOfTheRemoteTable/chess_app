require 'rails_helper'

RSpec.describe Knight do
  it 'has type of Knight' do
    expect(subject.type).to eq 'Knight'
  end

  describe '#valid_move?' do
    let(:knight) { create(:knight, position_x: 4, position_y: 4) }

    it 'returns true if the x and y move components are 1 and 2, respectively' do
      expect(knight.valid_move?(5, 6)).to eq true
    end

    it 'returns true if the x and y move components are 2 and 1, respectively' do
      expect(knight.valid_move?(6, 5)).to eq true
    end

    it 'returns false if out of bounds' do
      knight = create(:knight, position_x: 7, position_y: 4)
      expect(knight.valid_move?(9, 5)).to eq false
    end

    it 'returns false otherwise' do
      expect(knight.valid_move?(6, 6)).to eq false
    end
  end
end
