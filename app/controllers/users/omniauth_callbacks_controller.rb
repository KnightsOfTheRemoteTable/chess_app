module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def facebook
      @user = User.from_omniauth(request.env['omniauth.auth'])

      return sign_in_and_prompt_for_username(user) if @user.persisted?

      session['devise.facebook_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end

    private

    def sign_in_and_prompt_for_username(user)
      sign_in user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
      redirect_to username_path
    end
  end
end
