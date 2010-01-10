namespace :heroku do
	task :deploy do
		puts "***** DEPLOYING 'master' TO 'heroku' *****"
		sh "git push heroku master"
		sh "heroku rake db:migrate:redo"
		sh "heroku rake db:seed"
	end
end
