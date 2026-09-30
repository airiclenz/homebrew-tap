class Apogee < Formula
  desc "Terminal coding agent built for smaller local models, better with bigger ones"
  homepage "https://github.com/airiclenz/apogee"
  version "0.24.2"
  license "MIT"

  # Installs the prebuilt binary for this platform rather than compiling, so no Go
  # toolchain is needed. The tree is CGO-free and every OS-specific confinement
  # backend sits behind a build tag, so all six release targets come off one
  # `make dist` in the project repo.
  on_macos do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.24.2/apogee_0.24.2_darwin_arm64.tar.gz"
      sha256 "7e0192c49e08cb0547f2da1c29a1c74239a1b98c3d866d1cae097b0bbfbfd230"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.24.2/apogee_0.24.2_darwin_amd64.tar.gz"
      sha256 "f1049961fab9bfae850a540470bba85ac15b0609876a0d79827200de6fee1c23"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.24.2/apogee_0.24.2_linux_arm64.tar.gz"
      sha256 "0a5e19687912a4fba6fce735e621a309138aec611b8c052e3c79491efda3471f"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.24.2/apogee_0.24.2_linux_amd64.tar.gz"
      sha256 "d2181f4d7193c9aedbecd01ca3592c583d4e79fe336213cffdc53e409ad690cb"
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
