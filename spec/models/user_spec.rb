require 'rails_helper'

RSpec.describe User do
  it { is_expected.to validate_presence_of :username }
end
