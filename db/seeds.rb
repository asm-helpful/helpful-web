# --- Account ---
supportly = Account.create(name: 'Supportly')

# --- User ---
user = User.create!(email: 'user@example.com', password: 'password', password_confirmation: 'password')
Membership.create!(account: supportly, user: user, role: 'owner')