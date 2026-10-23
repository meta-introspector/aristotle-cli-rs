# Nix package for 932247ec-4b02-4568-a780-871ffcb5e6cf
{
    description = "Aristotle Project 932247ec-4b02-4568-a780-871ffcb5e6cf deployment";
    version = "0.1.0";
    src = ./.;
    buildInputs = [ ];
    
    buildCommand = ''
        mkdir -p $out
        cp -r * $out/
    '';
    
    meta = with lib; {
        maintainer = "mdupont";
        description = "Aristotle Project 932247ec-4b02-4568-a780-871ffcb5e6cf deployment";
        license = "MIT";
        platforms = [ "x86_64-linux" ];
    };
}
