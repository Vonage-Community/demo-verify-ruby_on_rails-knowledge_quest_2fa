class PagesController < ApplicationController
  include TwoFactorAuthentication
  allow_unauthenticated_access only: %i[ home ]
  allow_two_factor_unauthenticated_access except: %i[ two_factor_authenticated ]
  def home
  end

  def authenticated
  end

  def two_factor_authenticated
  end
end
