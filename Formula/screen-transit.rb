class ScreenTransit < Formula
  desc "Bluetooth-triggered monitor input switcher for macOS"
  homepage "https://github.com/airiclenz/screen-transit"
  url "https://github.com/airiclenz/screen-transit/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "b57349c4cf48a5bb506c9ff3a2d3e027ef51272bfab8b6173877e643af299deb"
  license "MIT"

  depends_on :macos
  depends_on :xcode => :build

  def install
    version_swift = "// Auto-generated from VERSION — do not edit manually.\n" \
                    "let appVersion = \"#{version}\"\n"
    (buildpath/"Sources/screen-transit/Version.swift").atomic_write(version_swift)
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/screen-transit"
    bin.install "screen-transit-signing.sh"
  end

  def post_install
    config_dir = Pathname.new("#{Dir.home}/.config/screen-transit")
    config_file = config_dir/"config.yaml"

    unless config_file.exist?
      config_dir.mkpath
      config_file.write <<~YAML
        # screen-transit configuration
        #
        # Discovery commands:
        #   blueutil --paired                     Find Bluetooth MAC address
        #   system_profiler SPBluetoothDataType   Alternative for Bluetooth MAC
        #   m1ddc display list                    Find display number
        #   m1ddc get input                       Find current input code
        #
        # Common DDC/CI input codes (VCP 0x60) -- verify yours with m1ddc:
        #   15 = DisplayPort-1    16 = DisplayPort-2
        #   17 = USB-C             4 = HDMI-1         5 = HDMI-2
        #
        # Reload after editing:
        #   brew services restart screen-transit

        delay: 1.0

        rules:
          # Uncomment and edit the rules below.
          #
          # - name: "Keyboard connect -> DisplayPort"
          #   source: bluetooth
          #   device_id: "AA:BB:CC:DD:EE:FF"
          #   display: 1
          #   input: 15
          #   trigger: connect
          #
          # - name: "Keyboard disconnect -> USB-C"
          #   source: bluetooth
          #   device_id: "AA:BB:CC:DD:EE:FF"
          #   display: 1
          #   input: 17
          #   trigger: disconnect
      YAML
      ohai "Default config created at #{config_file}"
    end

    cert_name = "Screen Transit Local"

    if quiet_system("security", "find-certificate", "-c", cert_name)
      system bin/"screen-transit-signing.sh", bin/"screen-transit"
    else
      puts
      opoo <<~EOS
        No code-signing certificate found.
        Without it, macOS will prompt for Bluetooth permission on every launch.
      EOS
      ohai <<~EOS
        Run once to fix:  screen-transit-signing.sh #{opt_bin}/screen-transit
      EOS
    end

    puts
    ohai "Start/stop as a background service:"
    puts "  brew services start screen-transit"
    puts "  brew services stop screen-transit"
    puts
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
      Edit the config with your device values, then start the service:

        #{Dir.home}/.config/screen-transit/config.yaml

      See https://github.com/airiclenz/screen-transit#configuration
    EOS

    parts.join("\n")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/screen-transit --version")
  end
end
