{ inputs, config, ... }: {
  environment.systemPackages = with inputs.neu-nix.packages.${system}; [
    neuwld
    neuswc
    neumenu
    wawa
    wsxwm
    hst
    hack
    mojito

  ];
}
