require 'hashdiff'

class Enzyme

  def self.hash_compare(h1, h2, options={})
    if options[:shallow]
      # do shallow comparison for performance, if fails do deep comparison to get difference
      options.delete(:shallow)
      h1 == h2 ? [] : Hashdiff.diff(h1, h2, options)
    else
      Hashdiff.diff(h1, h2, options)
    end

  end

end
