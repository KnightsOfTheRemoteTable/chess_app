require 'rails_helper'

RSpec.describe Rook do
  it 'has type of Rook' do
    expect(subject.type).to eq 'Rook'
  end
end
