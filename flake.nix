{
  description = "kris3713's nix flake for flutter development";

  # Flake inputs
  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*";

  # Flake outputs
  outputs = {self, ...} @ inputs: let
    # The systems supported for this flake's outputs
    supportedSystems = [
      "x86_64-linux" # 64-bit Intel/AMD Linux
      "aarch64-linux" # 64-bit ARM Linux
    ];

    # Helper for providing system-specific attributes
    forEachSupportedSystem = with inputs;
      f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
            f {
              inherit system;
              # Provides a system-specific, configured Nixpkgs
              pkgs = import nixpkgs {
                inherit system;
                # Enable using unfree packages
                config.allowUnfree = true;
              };
            }
        );
  in {
    # Development environments output by this flake

    # To activate the default environment:
    # nix develop
    # Or if you use direnv:
    # direnv allow
    devShells = forEachSupportedSystem ({
      pkgs,
      system,
    }: {
      # Run `nix develop` to activate this environment or `direnv allow` if you have direnv installed
      default = pkgs.mkShellNoCC {
        # The Nix packages provided in the environment
        packages = with pkgs; [
          # flutter pkg is provided by mise
          cmake
          clang
          ninja
          glib.dev
          gtk3.dev
        ];

        # Set any environment variables for your development environment
        env = {};

        # Add any shell logic you want executed when the environment is activated
        shellHook = "";
      };
    });
  };
}
