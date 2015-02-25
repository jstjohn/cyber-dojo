
class Kata

  def initialize(katas,id)
    raise "Invalid Kata(id)" if !katas.valid?(id)
    @katas,@id = katas,id
  end

  attr_reader :katas, :id

  def start_avatar(avatar_names = Avatars.names.shuffle)
    free_names = avatar_names - avatars.names
    if free_names != [ ]
      avatar = Avatar.new(self,free_names[0])
      avatar.start
    end
    avatar
  end

  def path
    katas.path + outer(id) + '/' + inner(id) + '/'
  end

  def exists?
    dir.exists?
  end

  def active?
    avatars.active.count > 0
  end

  def avatars
    Avatars.new(self)
  end

  def age(now = Time.now.to_a[0..5].reverse)
    return 0 if !active?
    return (Time.mktime(*now) - earliest_light).to_i
  end

  def created
    Time.mktime(*manifest_property)
  end

  def visible_files
    manifest_property
  end

  def language
    dojo.languages[manifest_property]
  end

  def exercise
    dojo.exercises[manifest_property]
  end

private

  include ExternalDiskDir
  include ManifestProperty
  include IdSplitter
  
  def manifest_filename
    'manifest.json'
  end
  
  def manifest
    @manifest ||= JSON.parse(read(manifest_filename))
  end

  def read(filename)
    dir.read(filename)
  end
  
  def earliest_light
    Time.mktime(*avatars.active.map{ |avatar|
      avatar.lights[0].time
    }.sort[0])
  end

  def dojo
    katas.dojo
  end

end
