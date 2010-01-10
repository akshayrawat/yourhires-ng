namespace :heroku do
	task :deploy do
		puts "***** DEPLOY 'master' TO 'heroku' *****"
		sh "git push heroku master"
		sh "heroku rake db:redo" #since there is only going to be 1 migration
		sh "heroku rake db:seed"
	end
end
