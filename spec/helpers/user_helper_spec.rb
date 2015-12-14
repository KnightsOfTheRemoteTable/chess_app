require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do
  describe '#gravatar_for' do
    it 'gravatar image_tag' do
      user = create(:user)
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=50"

      expect(helper.gravatar_for(user)).to eq image_tag(gravatar_url, alt: user.username)
    end
  end
end
