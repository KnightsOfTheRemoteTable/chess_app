class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :username, presence: true

  def games
    Game.where(
      'white_player_id = :player_id OR black_player_id = :player_id',
      player_id: id
    )
  end
end
