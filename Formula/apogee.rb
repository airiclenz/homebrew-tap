class Apogee < Formula
  desc "Terminal coding agent built for smaller local models, better with bigger ones"
  homepage "https://github.com/airiclenz/apogee"
  version "0.15.0"
  license "MIT"

  # Installs the prebuilt binary for this platform rather than compiling, so no Go
  # toolchain is needed. The tree is CGO-free and every OS-specific confinement
  # backend sits behind a build tag, so all six release targets come off one
  # `make dist` in the project repo.
  on_macos do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.15.0/apogee_0.15.0_darwin_arm64.tar.gz"
      sha256 "1358157cdfb8d1475907cbfc0482a4a0e115cfcde14d46ba1b2033ecdf7823de"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.15.0/apogee_0.15.0_darwin_amd64.tar.gz"
      sha256 "387cbfa465ce83b0b09ba1541cba8f7af00bc73d29361f8eaa8a9f5849596fe6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.15.0/apogee_0.15.0_linux_arm64.tar.gz"
      sha256 "f51341c256a53b1fb98dc888c2bb286750445572c835b60cdb152e478ce4acab"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.15.0/apogee_0.15.0_linux_amd64.tar.gz"
      sha256 "9894c5d7f7713b3fba146586f5ddf63119ad3e5a5eb2b91356403aef861522cf"
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
