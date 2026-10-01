{
  description = "Json parser written in Rust";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, rust-overlay }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ rust-overlay.overlays.default ];
      };

      rustToolchain = pkgs.rust-bin.stable.latest.default.override {
        extensions = [ "rust-src" "rust-analyzer" "clippy" ];
        targets = [
          "x86_64-unknown-linux-gnu"
        ];
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          rustToolchain
        ];


        shellHook = ''
          echo "json-parser devShell"

          exec fish -C '
            set -gx IN_NIX_SHELL 1
            set -gx PROJECT_NAME "json-parser"

            function fish_prompt
              set_color brmagenta
              echo -n "($PROJECT_NAME) "
              set_color bryellow
              echo -n (prompt_pwd)
              set_color normal
              echo -n "> "
            end
          '
        '';
      };
    };
}
