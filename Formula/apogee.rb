class Apogee < Formula
  desc "Terminal coding agent built for smaller local models, better with bigger ones"
  homepage "https://github.com/airiclenz/apogee"
  version "0.20.0"
  license "MIT"

  # Installs the prebuilt binary for this platform rather than compiling, so no Go
  # toolchain is needed. The tree is CGO-free and every OS-specific confinement
  # backend sits behind a build tag, so all six release targets come off one
  # `make dist` in the project repo.
  on_macos do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.20.0/apogee_0.20.0_darwin_arm64.tar.gz"
      sha256 "7adaef9615c9db3bf577ddb7edc6f84bd57571f8471221f07d140b9d3613ec8e"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.20.0/apogee_0.20.0_darwin_amd64.tar.gz"
      sha256 "16966d0bf6b084ae3d66eeec736f7308bf8aa9feb31f1872837171c14afafcf9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.20.0/apogee_0.20.0_linux_arm64.tar.gz"
      sha256 "c809d461407fe1d1f5b6c8f2b99cff4f8e67613a1ec67346a9804e37d05f4e2e"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.20.0/apogee_0.20.0_linux_amd64.tar.gz"
      sha256 "a84261f767b6658e592b42adca9114fd55df2657e217a0d2e024a04ee8c17a5f"
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
