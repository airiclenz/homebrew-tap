class Apogee < Formula
  desc "Terminal coding agent built for smaller local models, better with bigger ones"
  homepage "https://github.com/airiclenz/apogee"
  version "0.24.10"
  license "MIT"

  # Installs the prebuilt binary for this platform rather than compiling, so no Go
  # toolchain is needed. The tree is CGO-free and every OS-specific confinement
  # backend sits behind a build tag, so all six release targets come off one
  # `make dist` in the project repo.
  on_macos do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.24.10/apogee_0.24.10_darwin_arm64.tar.gz"
      sha256 "0b6a16d20fbdd5105b28a90dfe411a3ba1699bbc9eac40e81bbcda64ea23965a"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.24.10/apogee_0.24.10_darwin_amd64.tar.gz"
      sha256 "6e6ccc38fe61ff652943d3debe78d4938d8fe6ecf9061ba24feec89fddcfe557"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.24.10/apogee_0.24.10_linux_arm64.tar.gz"
      sha256 "6a74f7797d763460e58541b7b3401e52caabba4e269e929529854e92e2dae852"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.24.10/apogee_0.24.10_linux_amd64.tar.gz"
      sha256 "176501575b42a478e5b56307957b1ce067b7b092c799cd0668a69e0f53c194d0"
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
