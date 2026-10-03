class Apogee < Formula
  desc "Terminal coding agent built for smaller local models, better with bigger ones"
  homepage "https://github.com/airiclenz/apogee"
  version "0.24.5"
  license "MIT"

  # Installs the prebuilt binary for this platform rather than compiling, so no Go
  # toolchain is needed. The tree is CGO-free and every OS-specific confinement
  # backend sits behind a build tag, so all six release targets come off one
  # `make dist` in the project repo.
  on_macos do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.24.5/apogee_0.24.5_darwin_arm64.tar.gz"
      sha256 "d5c5c529a44366cdac7610b85252918e29f859b6c64564bb5679eac2387e30a5"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.24.5/apogee_0.24.5_darwin_amd64.tar.gz"
      sha256 "a79bb38a4198c4bd0bfe80139eb04cf703d467cb5831998ab958057631cb6a86"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.24.5/apogee_0.24.5_linux_arm64.tar.gz"
      sha256 "d98dbc1980ada466ca6c276c831c03929234b66d3ea86e6e62d9ec6c5c3a97fc"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.24.5/apogee_0.24.5_linux_amd64.tar.gz"
      sha256 "0abb52d28e4c6acd1e22d1bfa078143665f719b4fd240d0c552b8b6c723c1afa"
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
