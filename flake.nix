{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    naersk,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    rust = pkgs.callPackage naersk {};
    buildInputs = with pkgs; [
      udev
      mesa
      libinput
      libxkbcommon
    ];
    nativeBuildInputs = with pkgs; [
      seatd
      wayland
      pkg-config
    ];
  in {
    packages.${system}.default = rust.buildPackage {
      src = ./.;
      inherit buildInputs nativeBuildInputs;
    };

    devShell.${system} = pkgs.mkShell {
      inherit buildInputs nativeBuildInputs;
    };
  };
}
