class ScreenTransit < Formula
  desc "Bluetooth-triggered monitor input switcher for macOS"
  homepage "https://github.com/airiclenz/screen-transit"
  url "https://github.com/airiclenz/screen-transit/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "6ac4130e552d453d0d4363e83ccaaca84ccf6ac5bb155a9940d13b573321c62e"
  license "MIT"

  depends_on :macos
  depends_on :xcode => :build

  def install
    # Version.swift is generated at build time by the GenerateVersion SwiftPM
    # plugin from the tarball's VERSION file — writing our own copy into
    # Sources/ would redeclare appVersion and break the build (>= 0.5.0).
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/screen-transit"
    bin.install "screen-transit-signing.sh"
  end

  def post_install
    # Note: Homebrew's post_install runs inside a sandbox that blocks writes
    # to ~/.config and modifications to the login keychain. Config creation
    # and first-time cert setup therefore live in `screen-transit --init`,
    # which the user runs once after install (see caveats).
    #
    # On subsequent upgrades the signing identity already exists, so we can
    # re-sign the freshly built binary here to preserve TCC permissions
    # (Bluetooth, etc.) across version bumps. quiet_system never raises.

    cert_name = "Screen Transit Local"
    # No -v: self-signed certs without explicit trust are excluded by
    # `-v` but still usable by codesign. We avoid trust settings on purpose.
    has_identity = quiet_system(
      "/bin/bash", "-c",
      "security find-identity -p codesigning | grep -q '\"#{cert_name}\"'",
    )

    if has_identity
      # Pathname -> String: newer Homebrew (Sorbet-typed) requires String
      # for argv0 in quiet_system; passing Pathname raises TypeError.
      quiet_system (bin/"screen-transit-signing.sh").to_s,
                   (bin/"screen-transit").to_s
    end
  end

  service do
    run [opt_bin/"screen-transit"]
    keep_alive true
    log_path var/"log/screen-transit/stdout.log"
    error_log_path var/"log/screen-transit/stderr.log"
  end

  def caveats
    legacy_bin   = "/usr/local/bin/screen-transit"
    legacy_plist = "#{Dir.home}/Library/LaunchAgents/com.screen-transit.agent.plist"
    legacy_files = [legacy_bin, legacy_plist].select { |path| File.exist?(path) }

    parts = []

    unless legacy_files.empty?
      bullets = legacy_files.map { |path| "    - #{path}" }.join("\n")
      parts << <<~EOS
        Legacy install detected. These files can conflict with the Homebrew
        install (PATH shadowing, duplicate launchd agents):

        #{bullets}

        Clean up with:
          launchctl unload #{legacy_plist} 2>/dev/null
          rm -f #{legacy_plist}
          sudo rm -f #{legacy_bin}

        Verify afterwards with:  screen-transit --doctor
      EOS
    end

    parts << <<~EOS
      First-time setup — run once:

        screen-transit --init

      This creates a default config and a self-signed certificate so that
      macOS Bluetooth permissions persist across upgrades. You will be
      prompted once for your login keychain password.

      Then edit your config and start the service:

        #{Dir.home}/.config/screen-transit/config.yaml
        brew services start screen-transit

      See https://github.com/airiclenz/screen-transit#configuration
    EOS

    parts.join("\n")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/screen-transit --version")
  end
end
