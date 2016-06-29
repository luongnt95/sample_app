module ApplicationHelper
	def full_title title=''
		base_title = "Ruby on Rails Tutorial Sample App"
		return "#{title} | #{base_title}" unless title.empty?
		base_title
	end
end
