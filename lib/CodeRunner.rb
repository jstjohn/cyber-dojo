
require 'CodeSaver'

module CodeRunner
  
  def self.run(sandbox_dir, language_dir, visible_files)
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # visible_files  are the code files from the browser (or test)
    # sandbox_dir    is the dir where the compile/run is to take place
    # language_dir   is the dir of the language associated with
    #                the visible_files, which may provide hidden_files
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Dir.mkdir sandbox_dir
    output = inner_run(sandbox_dir, language_dir, visible_files)
    system("rm -rf #{sandbox_dir}")
    output
  end
  
  def self.inner_run(sandbox_dir, language_dir, visible_files)
    visible_files.each do |filename,content|
      CodeSaver::save_file(sandbox_dir, filename, content)
    end
    language_fileset = LanguageFileSet.new(language_dir)
    language_fileset.hidden_filenames.each do |hidden_filename|
      system("ln '#{language_dir}/#{hidden_filename}' '#{sandbox_dir}/#{hidden_filename}'")
    end
    command  = "cd '#{sandbox_dir}';" +
               "./cyberdojo.sh"
    max_run_tests_duration = 10
    Files::popen_read(command, max_run_tests_duration)
  end

end
