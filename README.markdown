# Sinatra Authentication Framework

### Basics

Clone it. Add some routes. Use the helpers.

### Helpers

		current_user				#=> Returns current logged in user
		login_required				#=> Checks if a user is logged in
		admin_required				#=> Checks if user is an admin
		is_owner? :id				#=> Checks if logged in user has same id as requested