class Apogee < Formula
  desc "Terminal coding agent built local-first, engineered so small LLMs deliver"
  homepage "https://github.com/airiclenz/apogee"
  version "0.11.0"
  license "MIT"

  # Installs the prebuilt binary for this platform rather than compiling, so no Go
  # toolchain is needed. The tree is CGO-free and every OS-specific confinement
  # backend sits behind a build tag, so all six release targets come off one
  # `make dist` in the project repo.
  on_macos do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.11.0/apogee_0.11.0_darwin_arm64.tar.gz"
      sha256 "7bf7c524b3cfe4ebbc5328a0327894efe865865eb65f328982feaa8890c3b10b"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.11.0/apogee_0.11.0_darwin_amd64.tar.gz"
      sha256 "7279020c7a868e3a5dc19391374bbb18f1ce9228dbb8f37af3f47070e7e2ab72"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.11.0/apogee_0.11.0_linux_arm64.tar.gz"
      sha256 "431d1e3dc41fb5052d0dc41eb9acb052609075b8086ba83915f53b32f01512d3"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.11.0/apogee_0.11.0_linux_amd64.tar.gz"
      sha256 "f58d36ca5364c0afb000ae2508ba6eb54b53b4652e3de21df17bf134785999b4"
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
