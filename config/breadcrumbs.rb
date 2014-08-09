crumb :root do
  link "خانه", root_path
end

crumb :makes do
  link "برند", makes_path
end

crumb :make do |make|
  link make.name, make_path(make)
  parent :root
end

crumb :car_model do |car_model|
  link car_model.name, make_car_model_path(id: car_model.slug)
  parent :make, car_model.make
end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).