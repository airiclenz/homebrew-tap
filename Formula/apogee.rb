class Apogee < Formula
  desc "Terminal coding agent built for smaller local models, better with bigger ones"
  homepage "https://github.com/airiclenz/apogee"
  version "0.24.0"
  license "MIT"

  # Installs the prebuilt binary for this platform rather than compiling, so no Go
  # toolchain is needed. The tree is CGO-free and every OS-specific confinement
  # backend sits behind a build tag, so all six release targets come off one
  # `make dist` in the project repo.
  on_macos do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.24.0/apogee_0.24.0_darwin_arm64.tar.gz"
      sha256 "49b6ab5b4fd51a52c4c5d2576ccf615c9be2cb315ec64a856f32c19a6b5ac2bc"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.24.0/apogee_0.24.0_darwin_amd64.tar.gz"
      sha256 "e75b78e3b9ae5ea5307a8dfb07380d5bd3fc26fa659589ce357420e4127e94fe"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.24.0/apogee_0.24.0_linux_arm64.tar.gz"
      sha256 "5eb9f57e0317af8fd9250e5f69a89262d1f74a1c23ab77635ef131ef8d376ca6"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.24.0/apogee_0.24.0_linux_amd64.tar.gz"
      sha256 "8736e15eccd1ff948bfe969ea441a55c31e3c3f47f4ab9404f8b3380f35d2fca"
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
