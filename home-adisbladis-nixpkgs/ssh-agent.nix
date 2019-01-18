{ pkgs, ... }:

let
  pkcs11SO = "${pkgs.yubico-piv-tool}/lib/libykcs11.so.1.4.4";
  sshSock = "%t/ssh-agent.sock";
  askPass = "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";

in {

  systemd.user.services.ssh-agent = {
    Unit = {
      Description = "Vanilla ssh-agent";
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Environment = "SSH_ASKPASS=${askPass}";
      ExecStart = "${pkgs.openssh}/bin/ssh-agent -D -a ${sshSock} -P ${pkcs11SO}";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  systemd.user.services.pkcs-hotplug-watcher = let
    pkg = pkgs.callPackage ./pkcs-ssh-agent { };
  in {
    Unit = {
      After = [ "ssh-agent.service" ];
      Description = "SSH agent pkcs11 hotplug watcher";
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Environment = "SSH_AUTH_SOCK=${sshSock} SSH_ASKPASS=${askPass}";
      ExecStart = "${pkg}/bin/pkcs-ssh-agent --pkcs11-so ${pkcs11SO}";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

}
