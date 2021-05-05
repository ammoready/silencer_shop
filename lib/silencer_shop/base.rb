module SilencerShop
  class Base

    protected

    def requires!(*args)
      self.class.requires!(*args)
    end

    def self.requires!(hash, *params)
      hash_keys = hash.collect { |k, v| v.is_a?(Array) ? [k, v.collect(&:keys)] : k }.flatten

      params.each do |param|
        if param.is_a?(Array)
          raise ArgumentError.new("Missing required parameter: #{param.first}") unless hash_keys.include?(param.first)

          valid_options = param[1..-1]
          raise ArgumentError.new("Parameter: #{param.first} must be one of: #{valid_options.join(', ')}") unless valid_options.include?(hash[param.first])
        else
          raise ArgumentError.new("Missing required parameter: #{param}") unless hash_keys.include?(param)
        end
      end
    end

  end
end
