module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def facebook
      @user = User.from_omniauth(request.env['omniauth.auth'])

      return sign_in_and_prompt_for_username(@user, 'Facebook') if @user.persisted?

      session['devise.facebook_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end

    def google
      @user = User.from_omniauth(request.env['omniauth.auth'])

      return sign_in_and_prompt_for_username(@user, 'Google') if @user.persisted?

      session['devise.google_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end

    private

    def sign_in_and_prompt_for_username(user, provider)
      sign_in user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
      if user.username == user.uid
        redirect_to user_username_path(user)
      else
        redirect_to root_path
      end
    end
  end
end
