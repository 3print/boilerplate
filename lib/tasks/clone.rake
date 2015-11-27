desc "clone boilerplate into a brand new project"
task :clone, [:name] do |t, args|
  name = args[:name]
  rel_path = "../#{name}"

  to_be_removed = [
    "lib/tasks/clone.rake",
    "app/models/bp_*",
    "app/controllers/**/bp_*",
    "app/views/bp_*",
    "app/views/admin/bp_*",
    "spec/models/bp_*",
    "db/migrate/*_bp_*",
    "spec/factories/bp_*",
    "bp-gemfile.rb",
  ]

  TPrint.log "Cloning into #{name}"
  if Dir.exists? rel_path
    # The project was already existing
    TPrint.log "Folder #{name} already existing"
    project_initialization  = false

  else
    # We just initialized the project
    TPrint.log "Creating folder #{name}"
    project_initialization  = true
    Dir.mkdir rel_path
    FileUtils.touch "#{rel_path}/#{name.parameterize}-gemfile.rb"
    to_be_removed += [
      "config/database.yml",
      ".git/",
      "Readme",
      "Readme.md",
      "log",
      "tmp",
    ]
  end

  unless project_initialization
    backups = [
      "config/database.yml",
      "config/locales/*",
      "app/views/*",
      "app/helpers/application_helper.rb"
    ]

    backups.each_with_index do |tgt, i|
      Dir["#{rel_path}/#{tgt}"].each do |f|
        TPrint.log "Backing up #{"." * (i%3)}", kill_line: true
        FileUtils.cp f, "#{f}.bak"
      end
    end
  end

  TPrint.log "Copying files"
  Dir["./*"].each do |dir|
    unless dir =~ /.git/
      FileUtils.cp_r dir, rel_path
    end
  end

  to_be_removed.each_with_index do |tgt, i|
    Dir["#{rel_path}/#{tgt}"].each do |f|
      TPrint.log "Cleaning #{"." * (i%3)}", kill_line: true
      FileUtils.rm_rf f
    end
  end

  if project_initialization
    %x(cd #{rel_path}; git init)
    TPrint.log "Setting DB"
    FileUtils.mv "#{rel_path}/config/database.yml.tpl", "#{rel_path}/config/database.yml"
    db_config = open("#{rel_path}/config/database.yml").read
    db_config.gsub! 'PROJECT_NAME', name.parameterize
    f = open("#{rel_path}/config/database.yml", 'w')
    f.write db_config
    f.close
  else
    backups.each_with_index do |tgt, i|
      Dir["#{rel_path}/#{tgt}"].each do |f|
        TPrint.log "Restoring back up #{"." * (i%3)}", kill_line: true
        FileUtils.cp "#{f}.bak", f
      end
    end
  end

  TPrint.log "Installing bundle"
  %x(cd #{rel_path}; bundle install)
  if project_initialization
    TPrint.log "Creating DB"
    %x(cd #{rel_path}; bundle exec rake db:create)
    %x(cd #{rel_path}; bundle exec rake db:migrate)
    %x(cd #{rel_path}; cat Gemfile | grep '^ruby' | sed  s/'ruby '// | xargs rbenv local)
  end

  TPrint.log "Replacing project name"

  %x(cd #{rel_path}; grep -Rl BOILERPLATE_ONLY * | xargs sed -i '' 's/.*BOILERPLATE_ONLY.*//g')

  replacements = {
    "config/application.rb" => name.parameterize.underscore.camelcase,
    "config/locales/*.yml" => name.capitalize,
    "config/initializers/session_store.rb" => name.parameterize.underscore,
  }
  replacements.each do |pattern, val|
    Dir["#{rel_path}/#{pattern}"].each do |file|
      content = open(file).read
      content = open(file).read
      content.gsub! /boilerplate/i, val
      f = open file, 'w'
      f.write content
      f.close
    end
  end

  TPrint.log "Done !"
end
