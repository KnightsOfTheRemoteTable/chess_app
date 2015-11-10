require 'rails_helper'

RSpec.describe Bishop do
  it 'has type of Bishop' do
    expect(subject.type).to eq 'Bishop'
  end
end
