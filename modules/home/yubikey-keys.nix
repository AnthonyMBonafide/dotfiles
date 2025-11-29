{ config, pkgs, ... }:

{
  # YubiKey U2F Authentication Keys
  # ================================
  # This file configures PAM U2F authentication for login and sudo.
  # Contains public key material only (safe to commit to Git).
  #
  # IMPORTANT: The u2f_keys file CANNOT contain comments - PAM U2F will fail to parse it.
  # All documentation must be kept here in the Nix file as Nix comments.
  #
  # To add or regenerate keys:
  # 1. Insert your YubiKey
  # 2. Run: pamu2fcfg -u anthony
  # 3. For multiple YubiKeys, append additional keys with colons:
  #    anthony:key1Handle,key1PublicKey:key2Handle,key2PublicKey:key3Handle,key3PublicKey
  #
  # Current configuration: 3 YubiKeys enrolled
  # Used for: sudo authentication, login authentication (via PAM)
  # Not used for: LUKS disk encryption (that uses FIDO2, configured separately)
  #
  # Format: username:keyHandle,publicKey,algorithm,flags[:keyHandle2,publicKey2,algorithm2,flags2]

  home.file.".config/Yubico/u2f_keys".text = ''
    anthony:epwGUynoZTAbiH8V+iPlMkk8DxtvH8sJV4p8rINX9Fml0a2tE4VQ/cLyUmW67M1QMsvtqiuB1boDAWCIjw9sOg==,NfGwHWPd9J5Zd5fafueEG4P42/5gMDq2fGCpR5I6tZsdJEBA1T7Uk4TmdKNu7ckZO12ihFNg9rL8/lAIqtFczg==,es256,+presence:ghEOtSRH+HKfkMDhz0t7Ar0E4Io/EL7x+TAg6YcidA2DntODjOZXS7K4ecfSyxL1RjamKMTGO8q462f3AOmfcw==,PuG12G8Rt325phw9DqiSmpJXWHv6QWp9iZ8i8Gb7Qr1YqIH0cwIH7MRMDPJQwE+ddQHNPutoTbcGmBrGVAKM2w==,es256,+presence:LNEK48k7jxLfXFKqxXw3LjJDakZmdwKQaweFgg0JW611+uxUh9AUUSGpYDyneAwBIYlwLkTNVqb7Yh+WB9Tq4g==,TPN7eJv0B7vLBxINQDdhsfD+WclHTqv6xsurFqxuJnKL6FrCd9l6vViUS2suea+wplbIIh0ltZzK/MtaUiLtEQ==,es256,+presence
  '';

  # Ensure the directory exists
  home.file.".config/Yubico/.keep".text = "";
}
