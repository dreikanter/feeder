require 'base64'
require 'fileutils'
require 'logger'
require 'digest/md5'

class SecretsVault
  PUBLIC_KEY = ENV['SECRETS_VAULT_PUBLIC_KEY'] || '/secrets/secret_vault_key.pub'
  PRIVATE_KEY = ENV['SECRETS_VAULT_PRIVATE_KEY'] || '/secrets/secret_vault_key'
  APPLICATION_CONFIG = 'application.yml'
  APPLICATION_CONFIG_ENCRYPTED = "#{APPLICATION_CONFIG}.enc"

  CONFIG_DIR = '../../../config'
  SEP = "###"

  def self.encrypt(options = {})
    new.send(:encrypt)
  end

  def self.decrypt(options = {})
    new.send(:decrypt)
  end

  private

  def initialize(options = {})
    @logger = Logger.new(STDOUT)
  end

  def encrypt
    check_file_exists('configuration file', config_path)
    logger.info "encrypting #{config_path}"

    cipher = new_cipher
    cipher.encrypt
    cipher.key = random_key = cipher.random_key
    cipher.iv = random_iv = cipher.random_iv

    contents = File.read(config_path)
    logger.info "md5: #{Digest::MD5.hexdigest(contents)}"

    payload = [
      public_key.public_encrypt(random_key),
      public_key.public_encrypt(random_iv),
      cipher.update(contents) + cipher.final
    ].map { |p| Base64.encode64(p) }.join(SEP)

    File.open(encrypted_config_path, 'wt') { |f| f.write(payload) }
  end

  def decrypt
    check_file_exists('encrypted configuration file', encrypted_config_path)
    logger.info "decrypting #{config_path}"

    cipher = new_cipher
    cipher.decrypt

    encrypted_key, encrypted_iv, encrypted_contents = encrypted_config_parts
    cipher.key = private_key.private_decrypt(encrypted_key)
    cipher.iv = private_key.private_decrypt(encrypted_iv)
    contents = cipher.update(encrypted_contents) + cipher.final

    if File.exists?(config_path)
      FileUtils.mv(config_path, "#{config_path}.backup", force: true)
    end

    File.open(config_path, 'wt') { |f| f.write(contents) }
    logger.info "md5: #{Digest::MD5.hexdigest(contents)}"
  end

  def new_cipher
    OpenSSL::Cipher::Cipher.new('aes-256-cbc')
  end

  def expand_path(path)
    File.expand_path(File.join(CONFIG_DIR, path), __FILE__)
  end

  def config_path
    expand_path APPLICATION_CONFIG
  end

  def encrypted_config_path
    expand_path APPLICATION_CONFIG_ENCRYPTED
  end

  def public_key_path
    expand_path PUBLIC_KEY
  end

  def private_key_path
    expand_path PRIVATE_KEY
  end

  def public_key
    @public_key ||= load_public_key
  end

  def load_public_key
    check_file_exists('Public key', public_key_path)
    OpenSSL::PKey::RSA.new(File.read(public_key_path))
  end

  def private_key
    @private_key ||= load_private_key
  end

  def load_private_key
    check_file_exists('Private key', private_key_path)
    OpenSSL::PKey::RSA.new(File.read(private_key_path))
  end

  def check_file_exists(description, path)
    return if File.exists?(path)
    puts "#{description} not found at #{path}"
    exit
  end

  def encrypted_config_parts
    File.read(encrypted_config_path).split(SEP).map { |p| Base64.decode64(p) }
  end

  def logger
    @logger
  end
end
