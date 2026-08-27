class Apogee < Formula
  desc "Terminal coding agent built for smaller local models, better with bigger ones"
  homepage "https://github.com/airiclenz/apogee"
  version "0.18.0"
  license "MIT"

  # Installs the prebuilt binary for this platform rather than compiling, so no Go
  # toolchain is needed. The tree is CGO-free and every OS-specific confinement
  # backend sits behind a build tag, so all six release targets come off one
  # `make dist` in the project repo.
  on_macos do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.18.0/apogee_0.18.0_darwin_arm64.tar.gz"
      sha256 "67a6dbdbacbfbf7a228b4d792ab323e2f00e8caade2b0c0a12241c9018bb501a"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.18.0/apogee_0.18.0_darwin_amd64.tar.gz"
      sha256 "211229dc1e1ca326fb7e8480b9664f53c790a381eb3fa1fa44cc554069d28629"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.18.0/apogee_0.18.0_linux_arm64.tar.gz"
      sha256 "6e87533231a087aec175d1cd8043d22ab319f7d432ccee40df3fe71f9a502489"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.18.0/apogee_0.18.0_linux_amd64.tar.gz"
      sha256 "5413f675d3dd1874ccbcad2b3b64e13317954ba8999fe261d32dc468c6fa8144"
    end
  end

  def install
    bin.install "apogee"
  end

  def caveats
    <<~EOS
      apogee needs an OpenAI-compatible endpoint — a local server (llama.cpp, Ollama,
      LM Studio, vLLM) needs no API key:

        apogee --endpoint http://localhost:8080 --model <name>

      `apogee probe` reports what this host can enforce for Auto mode, for free and
      without calling a model.
    EOS
  end

  test do
    # --version prints "apogee version vX.Y.Z+<build provenance>".
    assert_match version.to_s, shell_output("#{bin}/apogee --version")
    assert_match "apogee", shell_output("#{bin}/apogee --help")
  end
end
