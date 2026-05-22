class ScreenTransit < Formula
  desc "Bluetooth-triggered monitor input switcher for macOS"
  homepage "https://github.com/airiclenz/screen-transit"
  url "https://github.com/airiclenz/screen-transit/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "4442cf11589da394c729235313c6e19deb511237350fa898a445188cba2d5193"
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
    cert_name = "Screen Transit Local"

    if system("security", "find-certificate", "-c", cert_name, [:out, :err] => "/dev/null")
      system bin/"screen-transit-signing.sh", bin/"screen-transit"
    else
      puts
      opoo <<~EOS
        No code-signing certificate found.
        Without it, macOS will prompt for Bluetooth permission on every launch.
      EOS
      ohai <<~EOS
        Run this once to fix (will ask for your login keychain password):

          screen-transit-signing.sh #{opt_bin}/screen-transit

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
