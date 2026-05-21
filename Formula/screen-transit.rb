class ScreenTransit < Formula
  desc "Bluetooth-triggered monitor input switcher for macOS"
  homepage "https://github.com/airiclenz/screen-transit"
  url "https://github.com/airiclenz/screen-transit/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "f7e9341b0eab518a085d31b7679aee3292bf8868b22f4e11af455b6ad9ffac04"


  depends_on :macos
  depends_on :xcode => ["14.0", :build]

  def install
    version_swift = "// Auto-generated from VERSION — do not edit manually.\n" \
                    "let appVersion = \"#{version}\"\n"
    (buildpath/"Sources/screen-transit/Version.swift").write(version_swift)
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/screen-transit"
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
