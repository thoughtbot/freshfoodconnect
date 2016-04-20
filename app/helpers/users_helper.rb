module UsersHelper
  def render_user_rows(users, &block)
    render(layout: "users/row", locals: { users: users }, &block)
  end
end
