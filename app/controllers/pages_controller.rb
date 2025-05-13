class PagesController < ApplicationController
  allow_unauthenticated_access only: %i[ home ]
  def home
  end

  def authenticated
  end

  def two_factor_authenticated
  end
end
