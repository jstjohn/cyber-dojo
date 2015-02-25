
class Avatars

  def self.names
      %w(
          alligator buffalo cheetah deer
          elephant frog gorilla hippo iguana jaguar
          koala lion moose narwhal opposum panda quail
          raccoon snake trex unicorn vulture wolf xraytetra yak zebra
        )
  end

  def self.valid?(name)
    names.include?(name)
  end

  def initialize(kata)
    @kata = kata
  end

  def each
    return enum_for(:each) unless block_given?
    Avatars.names.each do |name|
      avatar = self[name]
      yield avatar if avatar.exists?
    end
  end

  def active
    each.select{ |avatar| avatar.active? }
  end

  def names
    each.collect{ |avatar| avatar.name }
  end
  
  def [](name)
    Avatar.new(@kata,name)
  end

end
