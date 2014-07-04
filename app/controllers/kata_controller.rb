root = '../..'

require_relative root + '/app/lib/Cleaner'
require_relative root + '/app/lib/FileDeltaMaker'
require_relative root + '/app/lib/MakefileFilter'
require_relative root + '/lib/TimeNow'

class KataController < ApplicationController

  def edit
    @kata = dojo.katas[id]
    @avatar = @kata.avatars[params[:avatar]]
    @tab = @kata.language.tab
    @visible_files = @avatar.tags.latest.visible_files
    @new_files = { }
    @filenames_to_delete = [ ]
    @traffic_lights = @avatar.lights.each.entries
    @output = @visible_files['output']
    @title = id[0..5] + ' ' + @avatar.name + "'s code"
  end

  def run_tests
    @kata   = dojo.katas[id]
    @avatar = @kata.avatars[params[:avatar]]

    was = params[:file_hashes_incoming]
    now = params[:file_hashes_outgoing]
    delta = FileDeltaMaker.make_delta(was, now)
    visible_files = received_files
    time_limit = 15

    pre_test_filenames = visible_files.keys
    @traffic_lights = @avatar.test(delta, visible_files, time_limit, time_now)
    @new_files = visible_files.select { |filename|
      !pre_test_filenames.include?(filename)
    }
    @filenames_to_delete = pre_test_filenames.select { |filename|
      !visible_files.keys.include?(filename)
    }

    @output = visible_files['output']

    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def help_dialog
    @avatar_name = params[:avatar_name]
    render :layout => false
  end

private

  include Cleaner
  include TimeNow

  def received_files
    seen = { }
    (params[:file_content] || {}).each do |filename,content|
      content = clean(content)
      # Cater for windows line endings from windows browser
      content = content.gsub(/\r\n/, "\n")
      # Cater for jquery-tabby.js plugin
      seen[filename] = MakefileFilter.filter(filename,content)
    end
    seen
  end

end
