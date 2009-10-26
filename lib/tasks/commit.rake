task :commit  => :'spec' do
  sh "git diff | mate"
  sh "git add ."
  sh "git add -u ."
  puts "Commit Message:"
  commit_message= STDIN.readline
  sh "git commit -m '#{commit_message}'"
  sh "git push origin"
end