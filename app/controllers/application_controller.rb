class ApplicationController < ActionController::Base
  include CartsHelper
  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :load_content_cart
  before_action :load_search_products
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def load_cart_session
    session[:carts] ||= {}
    @carts = session[:carts]
  end

  def load_category_product_type
    @categories = Category.sort_by_name.pluck :id, :name
    @product_types = ProductType.sort_by_name.pluck :id, :name
  end

  def load_content_cart
    load_cart_session
    @products_cart = Product.by_ids @carts.keys
    @total_price = total_price @carts, @products_cart
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up,
      keys: [:name, :sex, :birthday, :phone, :address]
  end

  def current_user? user
    user == current_user
  end

  rescue_from CanCan::AccessDenied do |exception|
    if user_signed_in?
      flash[:danger] = exception.message
      redirect_to root_url
    else
      flash[:danger] = t "users.you_need_login"
      redirect_to new_user_session_path
    end
  end

  def load_search_products
    @q = Product.ransack params[:q]
  end
end
