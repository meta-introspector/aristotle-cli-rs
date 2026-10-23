# Nix package for 94f804e0-02d4-41bd-a283-73eefe8bf9c3
{
    description = "Aristotle Project 94f804e0-02d4-41bd-a283-73eefe8bf9c3 deployment";
    version = "0.1.0";
    src = ./.;
    buildInputs = [ ];
    
    buildCommand = ''
        mkdir -p $out
        cp -r * $out/
    '';
    
    meta = with lib; {
        maintainer = "mdupont";
        description = "Aristotle Project 94f804e0-02d4-41bd-a283-73eefe8bf9c3 deployment";
        license = "MIT";
        platforms = [ "x86_64-linux" ];
    };
}
