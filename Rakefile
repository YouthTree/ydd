require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "ydd"
    gem.summary = %Q{ydd dumps / loads rails app databases for backup purposes.}
    gem.description = %Q{
YDD is a tool (a fork of yaml_db really) to make it generally easy
to use it for things like copying databases from production to staging
and the like.
}
    gem.email = "sutto@sutto.net"
    gem.homepage = "http://github.com/YouthTree/ydd"
    gem.authors = ["Adam Wiggins","Orion Henry", "Darcy Laycock"]
    gem.add_dependency 'thor', '~> 0.14'
    gem.add_dependency 'activesupport', '~> 3.0.0'
    gem.add_dependency 'activerecord', '~> 3.0.0'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end
