class User < ActiveRecord::Base
  attr_accessible :identity_url
  attr_accessible :username
  attr_accessible :email
end
