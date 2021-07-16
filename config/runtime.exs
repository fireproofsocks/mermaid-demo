import Config
import Dotenvy

# For local development, read dotenv files inside the envs/ dir;
# for releases, read them at the RELEASE_ROOT
config_dir_prefix =
  System.fetch_env("RELEASE_ROOT")
  |> case do
    :error ->
      "envs/"

    {:ok, value} ->
      IO.puts("Loading dotenv files from #{value}")
      "#{value}/"
  end

source!([
  "#{config_dir_prefix}.env",
  "#{config_dir_prefix}.#{config_env()}.env",
  "#{config_dir_prefix}.#{config_env()}.local.env"
])

config :foo,
  goalkeeper: env!("GOALKEEPER", :string),
  fullback: env!("FULLBACK", :string),
  sweeper: env!("SWEEPER", :string)
