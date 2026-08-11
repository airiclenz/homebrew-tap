class Apogee < Formula
  desc "Terminal coding agent built local-first, engineered so small LLMs deliver"
  homepage "https://github.com/airiclenz/apogee"
  version "0.13.0"
  license "MIT"

  # Installs the prebuilt binary for this platform rather than compiling, so no Go
  # toolchain is needed. The tree is CGO-free and every OS-specific confinement
  # backend sits behind a build tag, so all six release targets come off one
  # `make dist` in the project repo.
  on_macos do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.13.0/apogee_0.13.0_darwin_arm64.tar.gz"
      sha256 "d3ff536e096ee39368abd3f777b13dfa823cd26104a59db633bc963f19d8d0ba"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.13.0/apogee_0.13.0_darwin_amd64.tar.gz"
      sha256 "9468b2e60664f88c9f06e1a7de552f3ffe327b915a058493834ad38340e038bf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.13.0/apogee_0.13.0_linux_arm64.tar.gz"
      sha256 "7ea88e59597d0e68a1075f9fbd7fc4c616ae2d80525021245fb17baa2125190e"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.13.0/apogee_0.13.0_linux_amd64.tar.gz"
      sha256 "6affa261b58fb2d3ce8d90f350cf807d8ffa5546e45f6994a04f46d2c476a90b"
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
