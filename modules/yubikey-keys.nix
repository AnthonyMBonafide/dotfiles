{ config, pkgs, ... }:

{
  # Declarative Yubikey U2F registration
  # This file contains public key material only (safe to commit to Git)

  home.file.".config/Yubico/u2f_keys".text = ''
    # Replace this placeholder with your actual Yubikey registration(s)
    #
    # To generate, run with your Yubikey inserted:
    #   pamu2fcfg -u anthony
    #
    # For multiple Yubikeys, run the command for each one and append with colons:
    #   anthony:key1Handle,key1PublicKey:key2Handle,key2PublicKey:key3Handle,key3PublicKey
    #
    # Example format:
    # anthony:abcdef123456...,uvwxyz789012...:ghijkl345678...,opqrst901234...
    #
    # IMPORTANT: Replace the line below with your actual registration data
    anthony:nSPwHs6OtkF2JcDHYV45m2GwtBadNAOzq8VkYIgklQ5k200nNU4+nam6zEVBRjiheE7UFnx7G4MTeRFwqZqUjw==,MuZUIDvpVeXGDNZPRBx2NJY92x/hz3T09EJkbKg4r6hMUfTclI1m4KOaYcc0wTGzjjitckqDN8WdxjtWd1vJXg==,es256,+presence:R497bowDnFSSl4gxbM4nVRfPjb54cAtEK6bVICgZf+dHYt5jigoDTGGlR1hbQrSzkqh+wNK4fj4agDIKG99NLg==,jDoOzXXFb+VGsFlUQXdwpxd0ck2dsLqNnU53t0+9KwWAXlWoCw61MFsjXUt4/Bx3+Kq2tI2A6b4AgB68KBMR1g==,es256,+presence:Y2KzVpjeIajKL1A1DYSvDFMrHqj+x8Qfg28oDIvWDyU54N/lwURJcod+vQ84EJ/IYZwmMnMXiggI6nET1NlyVA==,szbV6YFro5ecJs7xfSP+cK3NC+fzLRmYHVqL6tVk1RVziLtGl9bHthecUlz8FfnE1iAyWakwjHWajqS+y4NEKg==,es256,+presence
  '';

  # Ensure the directory exists
  home.file.".config/Yubico/.keep".text = "";
}
