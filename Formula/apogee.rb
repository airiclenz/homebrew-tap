class Apogee < Formula
  desc "Terminal coding agent built for smaller local models, better with bigger ones"
  homepage "https://github.com/airiclenz/apogee"
  version "0.19.0"
  license "MIT"

  # Installs the prebuilt binary for this platform rather than compiling, so no Go
  # toolchain is needed. The tree is CGO-free and every OS-specific confinement
  # backend sits behind a build tag, so all six release targets come off one
  # `make dist` in the project repo.
  on_macos do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.19.0/apogee_0.19.0_darwin_arm64.tar.gz"
      sha256 "0b15528e630c089a30b01ef55e672bb64e069e683095402e216d11e5eb416002"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.19.0/apogee_0.19.0_darwin_amd64.tar.gz"
      sha256 "0def674d0cdb67dc118dd2749805d132328b3c26af27393183a27a8a305a68bd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/airiclenz/apogee/releases/download/v0.19.0/apogee_0.19.0_linux_arm64.tar.gz"
      sha256 "e8b5eaf9f39b739744ddf24261d5f85730beabb1d19fa876f2e72dbbc5e5c0d3"
    end
    on_intel do
      url "https://github.com/airiclenz/apogee/releases/download/v0.19.0/apogee_0.19.0_linux_amd64.tar.gz"
      sha256 "64c4e14424faa1e54346c8870a2bd3d0af1d64d52264713eb66d4521f812b9f8"
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
