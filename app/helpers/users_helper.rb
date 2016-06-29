module UsersHelper
	def gravatar_for user, style={}
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
		default_style = {alt: user.name, size: "100x100", class: "gravatar"}
		default_style.each { |key, value| style[key] ||= default_style[key] }
		image_tag gravatar_url, style
	end
end
