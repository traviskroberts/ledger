class EnvConfig

  config = YAML.load_file(Rails.root.join('config/config.yml'))[Rails.env]

  @@config = Hashie::Mash.new(config)

  def self.method_missing(sym)
    @@config.send(sym)
  end
end
