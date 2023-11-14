{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSUserEnv {
  name = "google-cloud-sdk";

  targetPkgs = pkgs: [
    pkgs.python3
  ];
  
}).env
