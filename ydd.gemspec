# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ydd}
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Adam Wiggins", "Orion Henry", "Darcy Laycock"]
  s.date = %q{2011-06-09}
  s.default_executable = %q{ydd}
  s.description = %q{
YDD is a tool (a fork of yaml_db really) to make it generally easy
to use it for things like copying databases from production to staging
and the like.
}
  s.email = %q{sutto@sutto.net}
  s.executables = ["ydd"]
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.files = [
    ".rvmrc",
    "README.markdown",
    "Rakefile",
    "VERSION",
    "bin/ydd",
    "lib/ydd.rb",
    "lib/ydd/application.rb",
    "lib/ydd/data_manager.rb",
    "lib/ydd/schema_manager.rb",
    "lib/ydd/serialization_helper.rb",
    "lib/ydd/yaml_db.rb",
    "tasks/yaml_db_tasks.rake",
    "ydd.gemspec"
  ]
  s.homepage = %q{http://github.com/YouthTree/ydd}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{ydd dumps / loads rails app databases for backup purposes.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<thor>, ["~> 0.14"])
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_runtime_dependency(%q<rchardet>, [">= 0"])
      s.add_runtime_dependency(%q<activerecord>, [">= 2.3"])
    else
      s.add_dependency(%q<thor>, ["~> 0.14"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<rchardet>, [">= 0"])
      s.add_dependency(%q<activerecord>, [">= 2.3"])
    end
  else
    s.add_dependency(%q<thor>, ["~> 0.14"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<rchardet>, [">= 0"])
    s.add_dependency(%q<activerecord>, [">= 2.3"])
  end
end

