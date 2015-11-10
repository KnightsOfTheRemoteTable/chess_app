require 'rails_helper'

RSpec.describe Knight do
  it 'has type of Knight' do
    expect(subject.type).to eq 'Knight'
  end
end
