class Apogee < Formula
  desc "Terminal coding agent built local-first, engineered so small LLMs deliver"
  homepage "https://github.com/airiclenz/apogee"
  version "0.14.0"
  license "MIT"

  # Installs the prebuilt binary for this platform rather than compiling, so no Go
  # toolchain is needed. The tree is CGO-free and every OS-specific confinement
  # backend sits behind a build tag, so all six release targets come off one
  # `make dist` in the project repo.
  on_macos do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.14.0/apogee_0.14.0_darwin_arm64.tar.gz"
      sha256 "533c810235688e6870898054aa3876aa3ea7c27578456d3fd398a4620872ee64"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.14.0/apogee_0.14.0_darwin_amd64.tar.gz"
      sha256 "9481606c6b80c149dd43519a1b1d4d5f47e3c854557688772f7d6b798095d5b8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.14.0/apogee_0.14.0_linux_arm64.tar.gz"
      sha256 "d124b502be47e0e2777040943bdb4cd31cad179c65b41889ca8c4dd82cb725c3"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.14.0/apogee_0.14.0_linux_amd64.tar.gz"
      sha256 "833420a9d2d786feb4a3da4df918a79fdee8bb2cb9d22199b886af2c7fe3d96f"
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
