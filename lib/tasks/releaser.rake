desc 'Bumps up the version, tags, push (git) and releases to rubygems.org'
task :release do
  system "gem bump --tag --release"
end