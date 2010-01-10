namespace :heroku do
	task :deploy do
		sh "git push heroku master"
		sh "heroku rake db:migrate"
	end
end
