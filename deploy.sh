#!/usr/bin/env bash
# Optional mirror deploy to https://sudoshz.ir/ada/ (canonical host is https://ada.fsfp.ir/).
# Primary hosting is GitHub Pages + Cloudflare on ada.fsfp.ir.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

ZIP=/tmp/ada-deploy.zip
PHP=/tmp/ada-deploy.php
rm -f "$ZIP" "$PHP"

zip -rq "$ZIP" . \
  -x '.git/*' \
  -x '.git' \
  -x 'deploy.sh' \
  -x '*.swp' \
  -x '*~'

cat > "$PHP" <<'PHP'
<?php
header('Content-Type: text/plain; charset=utf-8');
error_reporting(E_ALL);
ini_set('display_errors', '1');
ini_set('memory_limit', '512M');
ini_set('max_execution_time', '180');

$web = __DIR__;
$dest = $web.'/ada';
$staging = $web.'/ada-staging';
$backup = $web.'/ada-prev';
$zipPath = $web.'/ada-deploy.zip';

if (!is_file($zipPath)) {
    http_response_code(500);
    echo "zip missing\n";
    exit;
}

function rmTree(string $dir): void
{
    if (!is_dir($dir)) {
        return;
    }
    $it = new RecursiveIteratorIterator(
        new RecursiveDirectoryIterator($dir, FilesystemIterator::SKIP_DOTS),
        RecursiveIteratorIterator::CHILD_FIRST
    );
    foreach ($it as $f) {
        $f->isDir() ? @rmdir($f->getPathname()) : @unlink($f->getPathname());
    }
    @rmdir($dir);
}

rmTree($staging);
if (!mkdir($staging, 0755, true)) {
    http_response_code(500);
    echo "staging mkdir fail\n";
    exit;
}

$zip = new ZipArchive();
if ($zip->open($zipPath) !== true) {
    http_response_code(500);
    echo "zip open fail\n";
    exit;
}
$zip->extractTo($staging);
$zip->close();
echo "extracted to staging\n";

if (!is_file($staging.'/index.html')) {
    http_response_code(500);
    echo "staging missing index.html\n";
    rmTree($staging);
    exit;
}

rmTree($backup);
if (is_dir($dest) && !@rename($dest, $backup)) {
    http_response_code(500);
    echo "backup rename fail\n";
    rmTree($staging);
    exit;
}
if (!@rename($staging, $dest)) {
    http_response_code(500);
    echo "swap fail, restoring backup\n";
    if (is_dir($backup)) {
        @rename($backup, $dest);
    }
    rmTree($staging);
    exit;
}

rmTree($backup);
@unlink($zipPath);
@unlink(__FILE__);
echo "COMPLETE OK\n";
PHP

sftp -o BatchMode=yes sudoshz <<EOF
put $ZIP public_html/ada-deploy.zip
put $PHP public_html/ada-deploy.php
bye
EOF

echo "Extracting on production..."
curl -fsS "https://sudoshz.ir/ada-deploy.php"
echo
echo "Smoke:"
for p in /ada/ /ada/book/ /ada/presentation/; do
  printf "  %s -> " "$p"
  curl -sS -o /dev/null -w "%{http_code}\n" "https://sudoshz.ir$p"
done

rm -f "$ZIP" "$PHP"
echo "Ada deployed independently to https://sudoshz.ir/ada/"
