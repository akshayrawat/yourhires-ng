namespace :heroku do
	task :deploy do
		puts "***** DEPLOY 'master' TO 'heroku' *****"
		sh "git push heroku master"
		sh "heroku rake db:drop"
		sh "heroku rake db:migrate"
		sh "heroku rake db:seed"
	end
end
