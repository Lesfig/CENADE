module ApplicationHelper
	def current_menu(path)
		path.each do |p|
			return "active" if request.url.include?(p)
		end
	end
		
	def current_submenu(path)
		path.each do |p|
			return "active" if request.url.include?(p)
		end
	end	

	def current_sidebar(path)
		path.each do |p|
			return "active" if request.url.include?(p)
		end
	end	
end
