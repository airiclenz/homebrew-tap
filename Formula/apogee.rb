class Apogee < Formula
  desc "Terminal coding agent built for smaller local models, better with bigger ones"
  homepage "https://github.com/airiclenz/apogee"
  version "0.21.0"
  license "MIT"

  # Installs the prebuilt binary for this platform rather than compiling, so no Go
  # toolchain is needed. The tree is CGO-free and every OS-specific confinement
  # backend sits behind a build tag, so all six release targets come off one
  # `make dist` in the project repo.
  on_macos do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.21.0/apogee_0.21.0_darwin_arm64.tar.gz"
      sha256 "7030329a944ee5cbdd7fed405ac0382d1d63a1d0be0593e563adc8d869e2a3f1"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.21.0/apogee_0.21.0_darwin_amd64.tar.gz"
      sha256 "ecf5a56132d39fbacc961b18a646ab97431bd1fc4ba56bdea4acff618a30f2ce"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.21.0/apogee_0.21.0_linux_arm64.tar.gz"
      sha256 "592df74d75df37ef083322b08f06f94da594a5e68437b555066bfb3f1165583f"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.21.0/apogee_0.21.0_linux_amd64.tar.gz"
      sha256 "5cc8dee0776e0b6f89735619a18d68f333a35ce189cda6436f0e4e4ff7960654"
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
