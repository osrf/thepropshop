class SessionsController < ApplicationController
  def new
    @post = params
   
    openid_url = {
      'google' => 'https://www.google.com/accounts/o8/id',
      'yahoo' =>'yahoo.com',
      'aol' => 'aol.com',
      'openid' => 'myopenid.com'
    }

    # contains the logic for handling the stuff
    # obtained from the login process
    authenticate_with_open_id(openid_url[params[:auth]],
        :required => [:nickname, :email, 'http://axschema.org/contact/email',
          'http://schema.openid.net/contact/email',
          'http://openid.net/schema/contact/email']) do |result, identity_url, registration|
      ax_response = OpenID::AX::FetchResponse.from_success_response(request.env[Rack::OpenID::RESPONSE])

      # Create array of all possible emails
      email = [registration['email'], 
        ax_response['http://schema.openid.net/contact/email'],
        ax_response['http://openid.net/schema/contact/email'],
        ax_response['http://axschema.org/contact/email']]
      email = email[email.find_index{|x| not x.nil? and not x.empty?}][0]

      if result.successful?
        puts "Authentication successful"
        unless user = User.find_by_identity_url(identity_url)
          puts "Create new user"
          user = User.create(identity_url: identity_url)
          user.email = email
          user.save
        end

        sign_in user, params[:redirect]
      else
        puts "Render new"
        render 'new'
      end
    end

    # spits out a login form to start session
  end
 
  def create
    @post = params
  end

  def destroy
    logout
    redirect_to root_path
  end
end
