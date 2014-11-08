def load_yaml(config_file_path)
  YAML.load(File.open(config_file_path))
end
