class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    session[:redirect_url] = request.url
    redirect_to new_user_session_path, :alert => "You are not authorized to access #{request.url}. Please sign in."
  end

  before_filter do |controller|
    if user_signed_in? && (redirect_path = session.delete(:redirect_url))
      redirect_to redirect_path
    end
  end

  include EditHelper

  private

  def current_language
    Language.where('short_code = ?', params[:language_id]).first
  end
  helper_method :current_language

  def current_book
    Book.where('grandham_id = ?', params[:id]).first
  end
  helper_method :current_book
end