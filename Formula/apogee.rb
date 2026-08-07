class Apogee < Formula
  desc "Terminal coding agent built local-first, engineered so small LLMs deliver"
  homepage "https://github.com/airiclenz/apogee"
  version "0.12.0"
  license "MIT"

  # Installs the prebuilt binary for this platform rather than compiling, so no Go
  # toolchain is needed. The tree is CGO-free and every OS-specific confinement
  # backend sits behind a build tag, so all six release targets come off one
  # `make dist` in the project repo.
  on_macos do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.12.0/apogee_0.12.0_darwin_arm64.tar.gz"
      sha256 "26479b7e8041ea43bce411263333cf7d3dd190917d9ebaeef2a1454c84b32f83"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.12.0/apogee_0.12.0_darwin_amd64.tar.gz"
      sha256 "ad0ae23bcb15f58d6acab944f141d85aa76db9972764ca9ae33b27422ea5a660"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.12.0/apogee_0.12.0_linux_arm64.tar.gz"
      sha256 "decd14a476179d799ac08b5f2d247557a0c165833f162aa09934b6b094d87f87"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.12.0/apogee_0.12.0_linux_amd64.tar.gz"
      sha256 "129bb71ba3e52e9b4e8339cab6f9f5c962096da8c46c1a47387738d1dcbafac4"
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
