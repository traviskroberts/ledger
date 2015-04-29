class SiteController < ApplicationController
  def index
    render nothing: true, layout: "application"
  end
end
