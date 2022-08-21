{ config, pkgs, ... }: {
  config = {
    environment.systemPackages = with pkgs; [
      ##Plugins
      ##LV2
      aether-lv2
      ams-lv2
      artyFX
      boops
      bschaffl
      bsequencer
      bshapr
      cardinal
      distrho
      drumgizmo
      eq10q
      fmsynth
      fomp
      fverb
      gxmatcheq-lv2
      gxplugins-lv2
      infamousPlugins
      kapitonov-plugins-pack
      magnetophonDSP.CharacterCompressor
      magnetophonDSP.LazyLimiter
      magnetophonDSP.MBdistortion
      magnetophonDSP.RhythmDelay
      mda_lv2
      metersLv2
      mod-distortion
      mooSpace
      ninjas2
      noise-repellent
      plujain-ramp
      rkrlv2
      sfizz
      speech-denoiser
      swh_lv2
      talentedhack
      tunefish
      x42-gmsynth
      x42-plugins
      ##LADSPA
      AMB-plugins
      FIL-plugins
      autotalent
      caps
      ladspaPlugins
      lsp-plugins
      nova-filters
      tap-plugins
      zam-plugins
      calf
      ##utilities
      ##
      ardour
      zyn-fusion
      carla
      hydrogen
      tenacity
      qjackctl
    ];
    security.pam.loginLimits = [
      {
        domain = "@audio";
        item = "memlock";
        type = "-";
        value = "unlimited";
      }
      {
        domain = "@audio";
        item = "rtprio";
        type = "-";
        value = "99";
      }
      {
        domain = "@audio";
        item = "nofile";
        type = "soft";
        value = "99999";
      }
      {
        domain = "@audio";
        item = "nofile";
        type = "hard";
        value = "99999";
      }
    ];

  };
}
