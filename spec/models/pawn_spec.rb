require 'rails_helper'

RSpec.describe Pawn do
  it 'has type of Pawn' do
    expect(subject.type).to eq 'Pawn'
  end
end
