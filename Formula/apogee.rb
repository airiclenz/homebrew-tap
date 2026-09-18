class Apogee < Formula
  desc "Terminal coding agent built for smaller local models, better with bigger ones"
  homepage "https://github.com/airiclenz/apogee"
  version "0.22.0"
  license "MIT"

  # Installs the prebuilt binary for this platform rather than compiling, so no Go
  # toolchain is needed. The tree is CGO-free and every OS-specific confinement
  # backend sits behind a build tag, so all six release targets come off one
  # `make dist` in the project repo.
  on_macos do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.22.0/apogee_0.22.0_darwin_arm64.tar.gz"
      sha256 "b3b2d18ce81dc3bd2dfb01f31b29073135f3ea47d2a3346dd68d32436d221098"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.22.0/apogee_0.22.0_darwin_amd64.tar.gz"
      sha256 "e7831905b9953f965d2aa9a81e403c92f925e7c652064613134240ddfc3b8a2a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.22.0/apogee_0.22.0_linux_arm64.tar.gz"
      sha256 "3decdfb2c81ea29778962a8e46b55f0724b111f6f89b147441fcce36b76fc995"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.22.0/apogee_0.22.0_linux_amd64.tar.gz"
      sha256 "959e74998b01cce44748ddf1ee3bd63f89cc85d341d71b59918975cbcd3a6bf3"
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
