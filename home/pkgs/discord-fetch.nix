{ pkgs, lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage {
  pname = "discord-fetch";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Sholk-linux";
    repo = "discord-fetch";
    rev = "main";               # или конкретный коммит, например "a1b2c3d"
    hash = "sha256-tt2SyBxpHXQdq+hVGqG/8pROzqyA5rz/s03NDQ1au8s=";      # на первой сборке используй fake, потом замени на реальный
  };

  cargoHash = "sha256-QMqquIoJsoOiYbvDKRZ0GOV9Ivh4OAKzNP0MFt51hMA=";   # тоже подставь fake, потом замени

  nativeBuildInputs = with pkgs; [ gcc ];

  meta = with lib; {
    description = "Update Discord status with system info";
    homepage = "https://github.com/Sholk-linux/discord-fetch";
    license = licenses.gpl3Only;
  };
}
