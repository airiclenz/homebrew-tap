class Apogee < Formula
  desc "Terminal coding agent built for smaller local models, better with bigger ones"
  homepage "https://github.com/airiclenz/apogee"
  version "0.16.0"
  license "MIT"

  # Installs the prebuilt binary for this platform rather than compiling, so no Go
  # toolchain is needed. The tree is CGO-free and every OS-specific confinement
  # backend sits behind a build tag, so all six release targets come off one
  # `make dist` in the project repo.
  on_macos do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.16.0/apogee_0.16.0_darwin_arm64.tar.gz"
      sha256 "8f3961c3eb5a74376fcf34d6cd4a684e8a0fe3f5152b6015d4c55b3ce345603a"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.16.0/apogee_0.16.0_darwin_amd64.tar.gz"
      sha256 "60e8aeb7f641efeef88ea9c60b1f605148e30d928f3c0bfac76d7a41f87fab3c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.16.0/apogee_0.16.0_linux_arm64.tar.gz"
      sha256 "b9fca4138d860fa450cc9f02958d253fe7dea5a60206abde8e4363dc282d6a9f"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.16.0/apogee_0.16.0_linux_amd64.tar.gz"
      sha256 "644c52934ed1b98b8fe9e9cd95d7e5046158d1a21028bc11f79509cb39032dc1"
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
