class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :google]
  validates :username, presence: true

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.username = auth.uid
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if (data = session['devise.facebook_data'] && session['devise.facebook_data']['extra']['raw_info'])
        user.email = data['email'] if user.email.blank?
      end
    end
  end

  def games
    Game.where(
      'white_player_id = :player_id OR black_player_id = :player_id',
      player_id: id
    )
  end

  def profile_data
    {
      name:          username,
      gravatar_url:  gravatar_url,
      playing_since: created_at.strftime('%m-%d-%Y'),
      total_wins:    wins_count
    }
  end

  def wins_count
    games.where(winner: self).count
  end

  def gravatar_url
    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    "https://secure.gravatar.com/avatar/#{gravatar_id}?s=75"
  end
end
