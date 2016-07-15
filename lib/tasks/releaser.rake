# frozen_string_literal: true
desc 'Bumps the version to the next patch level, tags and pushes the code to
origin repository and releases the gem. BOOM!'
task :release do
  system 'gem bump --tag --release'
end
