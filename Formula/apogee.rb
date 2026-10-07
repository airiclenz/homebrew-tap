class Apogee < Formula
  desc "Terminal coding agent built for smaller local models, better with bigger ones"
  homepage "https://github.com/airiclenz/apogee"
  version "0.24.9"
  license "MIT"

  # Installs the prebuilt binary for this platform rather than compiling, so no Go
  # toolchain is needed. The tree is CGO-free and every OS-specific confinement
  # backend sits behind a build tag, so all six release targets come off one
  # `make dist` in the project repo.
  on_macos do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.24.9/apogee_0.24.9_darwin_arm64.tar.gz"
      sha256 "b0283830744084391fe8bdb8d7368577246fca8126a7dbf725cae9699c604841"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.24.9/apogee_0.24.9_darwin_amd64.tar.gz"
      sha256 "97b70845b4b2dab0f41802aa440080374d42164efa1e742bc2143d9b7a89e69a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.24.9/apogee_0.24.9_linux_arm64.tar.gz"
      sha256 "63fe7e687e19271aaa6cdc0f03b7b8d5be8d51cc82cfc3b3106c4bd58f096896"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.24.9/apogee_0.24.9_linux_amd64.tar.gz"
      sha256 "375de2bee40ee5ad7177da947c8edfd3f520cc7aa2040b6c5ccb0af516e22a54"
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
