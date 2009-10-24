task :commit  => :'spec' do
  sh "git add ."
  sh "git add -u ."
  sh "git diff | mate"
  puts "Commit Message:"
  commit_message= STDIN.readline
  sh "git commit -m '#{commit_message}'"
  sh "git push origin"
end