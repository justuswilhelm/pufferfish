# Configuration for fd
{ pkgs, config, ... } :
{
  home.packages = [
    pkgs.fd
  ];
  # XXX darwin specific
  xdg.configFile."fd/ignore".text =
    # These are all directories that can't be walked through by fd, or cause
    # permission popups
    let
      username = config.home.username;
    in
    ''
      /Users/${username}/Library/Accounts
      /Users/${username}/Library/AppleMediaServices
      /Users/${username}/Library/Application Support/AddressBook
      /Users/${username}/Library/Application Support/CallHistoryDB
      /Users/${username}/Library/Application Support/CallHistoryTransactions
      /Users/${username}/Library/Application Support/CloudDocs
      /Users/${username}/Library/Application Support/DifferentialPrivacy
      /Users/${username}/Library/Application Support/FaceTime
      /Users/${username}/Library/Application Support/FileProvider
      /Users/${username}/Library/Application Support/Knowledge
      /Users/${username}/Library/Application Support/MobileSync
      /Users/${username}/Library/Application Support/com.apple.TCC
      /Users/${username}/Library/Application Support/com.apple.avfoundation
      /Users/${username}/Library/Application Support/com.apple.sharedfilelist
      /Users/${username}/Library/Assistant
      /Users/${username}/Library/Autosave Information
      /Users/${username}/Library/Biome
      /Users/${username}/Library/Caches
      /Users/${username}/Library/Calendars
      /Users/${username}/Library/ContainerManager
      /Users/${username}/Library/Containers
      /Users/${username}/Library/Cookies
      /Users/${username}/Library/CoreFollowUp
      /Users/${username}/Library/Daemon Containers
      /Users/${username}/Library/DoNotDisturb
      /Users/${username}/Library/DuetExpertCenter
      /Users/${username}/Library/Group Containers
      /Users/${username}/Library/HomeKit
      /Users/${username}/Library/IdentityServices
      /Users/${username}/Library/IntelligencePlatform
      /Users/${username}/Library/Mail
      /Users/${username}/Library/Messages
      /Users/${username}/Library/Metadata
      /Users/${username}/Library/PersonalizationPortrait
      /Users/${username}/Library/Reminders
      /Users/${username}/Library/Safari
      /Users/${username}/Library/Sharing
      /Users/${username}/Library/Shortcuts
      /Users/${username}/Library/StatusKit
      /Users/${username}/Library/Suggestions
      /Users/${username}/Library/Trial
      /Users/${username}/Library/Weather
      /Users/${username}/Library/com.apple.aiml.instrumentation
    '';
}
