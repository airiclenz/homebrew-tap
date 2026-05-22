class ScreenTransit < Formula
  desc "Bluetooth-triggered monitor input switcher for macOS"
  homepage "https://github.com/airiclenz/screen-transit"
  url "https://github.com/airiclenz/screen-transit/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "af6972a90783cc90e0e59a119bdb8c96b742615a1c1c3f0172abafe756a12feb"
  license "MIT"

  depends_on :macos
  depends_on :xcode => :build

  def install
    version_swift = "// Auto-generated from VERSION — do not edit manually.\n" \
                    "let appVersion = \"#{version}\"\n"
    (buildpath/"Sources/screen-transit/Version.swift").atomic_write(version_swift)
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/screen-transit"
    bin.install "setup-signing.sh"
  end

  def post_install
    cert_name = "Screen Transit Local"
    identities = `security find-identity -v -p codesigning 2>/dev/null`
    if identities.include?(cert_name)
      system "codesign", "-s", cert_name, "-f", bin/"screen-transit"
    else
      puts
      opoo <<~EOS
        No code-signing certificate found.
        Without it, macOS will prompt for Bluetooth permission on every launch.
      EOS
      ohai <<~EOS
        Run this once to fix:

          setup-signing.sh && codesign -s "#{cert_name}" -f #{bin}/screen-transit

      EOS
    end

    puts
    ohai <<~EOS
      To run screen-transit as a background service:

        brew services start screen-transit

      To stop:

        brew services stop screen-transit

    EOS
  end

  service do
    run [opt_bin/"screen-transit"]
    keep_alive true
    log_path var/"log/screen-transit/stdout.log"
    error_log_path var/"log/screen-transit/stderr.log"
  end

  def caveats
    <<~EOS
      First-time install: run the signing setup so macOS permanently
      remembers the Bluetooth permission (one password prompt):

        setup-signing.sh
        codesign -s "Screen Transit Local" -f #{bin}/screen-transit

      Future upgrades re-sign automatically — no action needed.

      Create your config file before starting the service:

        mkdir -p ~/.config/screen-transit
        screen-transit --help

      See https://github.com/airiclenz/screen-transit#configuration
      for config file format and discovery commands.

      To start the background service:
        brew services start screen-transit
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/screen-transit --version")
  end
end
