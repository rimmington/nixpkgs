{
  buildLua,
  curl,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildLua {
  pname = "twitch-chat";
  version = "0-unstable-2024-06-23";

  src = fetchFromGitHub {
    owner = "CrendKing";
    repo = "mpv-twitch-chat";
    rev = "bb0c2e84675f4f1e0c221c8e1d3516b60242b985";
    hash = "sha256-lnWYcr49koI60Su85OWbcxrARWTfXW2zIvfCZ6c3GtI=";

    postFetch = "rm $out/screenshot.webp";
  };

  scriptPath = ".";

  runtime-dependencies = [ curl ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Show Twitch chat messages as subtitles when watching Twitch VOD with mpv.";
    homepage = "https://github.com/CrendKing/mpv-twitch-chat";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.naho ];
  };
}
