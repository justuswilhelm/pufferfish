{ lib, pkgs, specialArgs, osConfig, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-esr;
    profiles.default = {
      isDefault = true;
      name = "Default profile";
      search.default = "Kagi";
      search.force = true;
      search.engines = {
        "Kagi" = {
          urls = [{
            template = "https://kagi.com/search?q={searchTerms}";
          }];
          definedAliases = [ "kagi" ];
        };
        "Bing".metaData.hidden = true;
        "Google".metaData.hidden = true;
        "Amazon.co.jp".metaData.hidden = true;
        "Wikipedia (en)".metaData.hidden = true;
      };
      # Hardening settings from
      # https://brainfucksec.github.io/firefox-hardening-guide
      settings = {
        "browser.aboutConfig.showWarning" = false;
        "browser.search.openInTab" = true;
        "browser.startup.page" = 0;
        "browser.newtabpage.enabled" = false;
        "browser.newtabpage.preload" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.newtabpage.activity-stream.feeds.snippets" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.default.sites" = "";
        "app.update.auto" = false;
        "extensions.getAddons.showPane" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "browser.discovery.enabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.coverage.opt-out" = true;
        "toolkit.coverage.opt-out" = true;
        "toolkit.coverage.endpoint.base" = "";
        "browser.ping-centre.telemetry" = false;
        "beacon.enabled" = false;
        "app.shield.optoutstudies.enabled" = false;
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";
        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false;
        "captivedetect.canonicalURL" = "";

        "network.captive-portal-service.enabled" = false;
        "network.connectivity-service.enabled" = false;
        "browser.safebrowsing.malware.enabled" = false;
        "browser.safebrowsing.phishing.enabled" = false;
        "browser.safebrowsing.blockedURIs.enabled" = false;
        "browser.safebrowsing.provider.google4.gethashURL" = "";
        "browser.safebrowsing.provider.google4.updateURL" = "";
        "browser.safebrowsing.provider.google.gethashURL" = "";
        "browser.safebrowsing.provider.google.updateURL" = "";
        "browser.safebrowsing.provider.google4.dataSharingURL" = "";
        "browser.safebrowsing.downloads.enabled" = false;
        "browser.safebrowsing.downloads.remote.enabled" = false;
        "browser.safebrowsing.downloads.remote.url" = "";
        "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false;
        "browser.safebrowsing.downloads.remote.block_uncommon" = false;
        "browser.safebrowsing.allowOverride" = false;
        "network.prefetch-next" = false;
        "network.dns.disablePrefetch" = true;
        "network.predictor.enabled" = false;
        "network.http.speculative-parallel-limit" = 0;
        "browser.places.speculativeConnect.enabled" = false;
        "permissions.manager.defaultsUrl" = "";
        "network.IDN_show_punycode" = true;
        "browser.search.suggest.enabled" = false;
        "browser.urlbar.suggest.searches" = false;
        "browser.fixup.alternate.enabled" = false;
        "browser.urlbar.trimURLs" = false;
        "browser.urlbar.speculativeConnect.enabled" = false;
        "browser.formfill.enable" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.available" = "off";
        "extensions.formautofill.creditCards.available" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "extensions.formautofill.heuristics.enabled" = false;
        "browser.urlbar.quicksuggest.scenario" = "history";
        "browser.urlbar.quicksuggest.enabled" = false;
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        "signon.rememberSignons" = false;
        "signon.autofillForms" = false;
        "signon.formlessCapture.enabled" = false;
        "network.auth.subresource-http-auth-allow" = 1;
        "browser.sessionstore.resume_from_crash" = false;
        "browser.pagethumbnails.capturing_disabled" = true;
        "browser.shell.shortcutFavicons" = false;
        "browser.helperApps.deleteTempFileOnExit" = true;
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_send_http_background_request" = false;
        "browser.xul.error_pages.expert_bad_cert" = true;
        "security.tls.enable_0rtt_data" = false;
        # "security.OCSP.require" = true;
        "security.pki.sha1_enforcement_level" = 1;
        "security.cert_pinning.enforcement_level" = 2;
        "security.remote_settings.crlite_filters.enabled" = true;
        "security.pki.crlite_mode" = 2;

        "network.http.referer.XOriginPolicy" = 2;
        "network.http.referer.XOriginTrimmingPolicy" = 2;
        "webgl.disabled" = true;
        "media.autoplay.default" = 5;
        "media.eme.enabled" = false;
        "browser.download.useDownloadDir" = false;
        "browser.download.manager.addToRecentDocs" = false;
        "browser.contentblocking.category" = "strict";
        "privacy.partition.serviceWorkers" = true;
        "privacy.partition.always_partition_third_party_non_cookie_storage" = true;
        "privacy.partition.always_partition_third_party_non_cookie_storage.exempt_sessionstorage" = true;
        "dom.disable_open_during_load" = true;
        "dom.popup_allowed_events" = "click dblclick mousedown pointerdown";
        "extensions.pocket.enabled" = false;
        "extensions.Screenshots.disabled" = true;
        "pdfjs.enableScripting" = false;
        "privacy.userContext.enabled" = true;
        "privacy.resistFingerprinting" = true;
      };
    };
  };
}

