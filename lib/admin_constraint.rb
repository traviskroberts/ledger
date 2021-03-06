class AdminConstraint
  def matches?(request)
    return false unless request.cookies["user_credentials"].present?
    user = User.find_by_persistence_token(request.cookies["user_credentials"].split(':')[0])
    user && user.super_admin?
  end
end
