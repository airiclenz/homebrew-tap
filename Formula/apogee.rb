class Apogee < Formula
  desc "Terminal coding agent built for smaller local models, better with bigger ones"
  homepage "https://github.com/airiclenz/apogee"
  version "0.17.1"
  license "MIT"

  # Installs the prebuilt binary for this platform rather than compiling, so no Go
  # toolchain is needed. The tree is CGO-free and every OS-specific confinement
  # backend sits behind a build tag, so all six release targets come off one
  # `make dist` in the project repo.
  on_macos do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.17.1/apogee_0.17.1_darwin_arm64.tar.gz"
      sha256 "8420ccd28dd97fce2c6ca5f5d2befc796503a7a9b1458b953a0801423073260b"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.17.1/apogee_0.17.1_darwin_amd64.tar.gz"
      sha256 "d4283f4baf9438bc5c5bce0f8c01b0ad5e5eb69fe67d91aa55bbad7452c6c20f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.17.1/apogee_0.17.1_linux_arm64.tar.gz"
      sha256 "0b4b9c5adc89e174a5851afdca20dc3b8e6eec0f393754c01b60d90f16d406e0"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.17.1/apogee_0.17.1_linux_amd64.tar.gz"
      sha256 "5796c9497807c17139682272559bb9e141179291eafeab8f9885c2ece1a9c196"
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
