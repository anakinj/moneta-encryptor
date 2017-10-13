require 'base64'
require 'openssl'

require 'moneta'

module Moneta
  # :nodoc:
  class Encryptor < Moneta::Proxy
    ENCRYPTION_KEY_KEY = :encryption_key

    def initialize(adapter, options = {})
      @default_key = options[ENCRYPTION_KEY_KEY]
      @algorithm   = options[:encryption_algorithm] || 'aes-256-cbc'
      validate_key_length!
      super
    end

    def load(key, options = {})
      value = super
      decrypt(value, encryption_key(options))
    end

    def store(key, value, options = {})
      super(key,
            encrypt(value, encryption_key(options)),
            Moneta::Utils.without(options, :encryption_key))
      value
    end

    private

    def validate_key_length!
      return if @default_key.nil?
      OpenSSL::Cipher.new(@algorithm).key = @default_key
    end

    def decrypt(value, key)
      return value if value.nil? || key.nil?
      return value unless value.is_a?(String) && value.include?('.')

      cipher = OpenSSL::Cipher.new(@algorithm)
      cipher.decrypt
      cipher.key = key
      cipher.iv, encrypted_value = extract_iv_and_value(value)

      decrypted_value = cipher.update(encrypted_value)
      decrypted_value << cipher.final

      decrypted_value
    end

    def encrypt(value, key)
      return value if key.nil? || !value.is_a?(String)
      cipher = OpenSSL::Cipher.new(@algorithm)
      cipher.encrypt
      cipher.key = key

      iv = cipher.random_iv

      encrypted_data = cipher.update(value)
      encrypted_data << cipher.final

      tuck_iv_and_value(iv, encrypted_data)
    end

    def encryption_key(options)
      options.fetch(ENCRYPTION_KEY_KEY, @default_key)
    end

    def tuck_iv_and_value(iv, encrypted_value)
      encoded_values = [iv, encrypted_value].map do |value|
        Base64.strict_encode64(value)
      end

      encoded_values.join('.')
    end

    def extract_iv_and_value(raw_value)
      raw_value.split('.').map { |value| Base64.strict_decode64(value) }
    end
  end
end
