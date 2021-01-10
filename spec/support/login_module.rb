module LoginModule
  def login(user)
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'rspec'
    click_button 'Login'
  end
end
