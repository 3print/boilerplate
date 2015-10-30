desc "clone boilerplate into a brand new project"
task :clone, [:name] do |t, args|
  name = args[:name]
  rel_path = "../#{name}"

  TPrint.log "Cloning into #{name}"
  if Dir.exists? rel_path
    TPrint.print_error "Folder #{name} already existing"
    next
  end
  TPrint.log "Creating folder #{name}"
  Dir.mkdir rel_path
  TPrint.log "Copying files"
  FileUtils.cp_r '.', rel_path

  to_be_removed = [
    "config/database.yml",
    "lib/tasks/clone.rake",
    "app/models/bp_*"
  ]
  to_be_removed.each_with_index do |tgt, i|
    TPrint.log "Cleaning #{"." * (i%3)}", kill_line: true
    FileUtils.rm_rf "#{rel_path}/#{tgt}"
  end
  TPrint.log "Done !"
end
