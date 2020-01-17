# frozen_string_literal: true

desc 'Bumps the version to the next patch level, tags and pushes the code to
origin repository'
task :bump do
  system 'gem bump --tag --push --skip-ci'
end

desc 'Releases the gem and pushes any tags to the origin repository'
task :release do
  system 'gem release --push'
end
