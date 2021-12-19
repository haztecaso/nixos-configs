{ pkgs, ... }: {
  virtualisation.oci-containers.containers.moodle-dl = {
    image = "pestotoast/moodle-dl";
  };
}
