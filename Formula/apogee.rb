class Apogee < Formula
  desc "Terminal coding agent built for smaller local models, better with bigger ones"
  homepage "https://github.com/airiclenz/apogee"
  version "0.23.0"
  license "MIT"

  # Installs the prebuilt binary for this platform rather than compiling, so no Go
  # toolchain is needed. The tree is CGO-free and every OS-specific confinement
  # backend sits behind a build tag, so all six release targets come off one
  # `make dist` in the project repo.
  on_macos do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.23.0/apogee_0.23.0_darwin_arm64.tar.gz"
      sha256 "6b04c4b34cdcc9348cb4aee7d0e1df2ab9963020f65e8de785053e67a5a27d20"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.23.0/apogee_0.23.0_darwin_amd64.tar.gz"
      sha256 "54516c0a7761c4b1e9df08e1341651b1e2add3a02d186cf47c2946820ac36872"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.23.0/apogee_0.23.0_linux_arm64.tar.gz"
      sha256 "46b65a662e81942c4782381918ebc000b93db960f919e6d1d1636835684b5c6b"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.23.0/apogee_0.23.0_linux_amd64.tar.gz"
      sha256 "bc10b29e52ec0bcc54deb75879a8244e9dce45cf70bc9917bf5f43a04394e5b3"
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
