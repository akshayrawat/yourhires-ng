task :commit  => :'spec' do
  puts "Commit Message:"
  commit_message= STDIN.readline
  sh "git add ."
  sh "git add -u ."
  sh "git commit -m '#{commit_message}'"
  sh "git push origin"
end