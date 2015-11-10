require 'rails_helper'

RSpec.describe Queen do
  it 'has type of Queen' do
    expect(subject.type).to eq 'Queen'
  end
end
