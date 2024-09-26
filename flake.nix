{
  description = "My dwm flake";

  outputs = { self }:
  {
    overlays.default = final: prev: {
      dwm = prev.dwm.overrideAttrs (oldAttrs: {
        src = ./.;
      });
    };
  };
}
