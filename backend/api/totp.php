<?php
declare(strict_types=1);

/**
 * TOTP (RFC 6238), compatible with Google Authenticator / Authy / any
 * standard authenticator app — no SMS or email sending needed, so this
 * works the same on any host regardless of whether outbound mail is
 * configured. Pure PHP, no external library.
 */

const TOTP_DIGITS = 6;
const TOTP_PERIOD = 30; // seconds per code

function totp_generate_secret(int $bytes = 20): string {
    return totp_base32_encode(random_bytes($bytes));
}

function totp_base32_encode(string $data): string {
    $alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
    $bits = '';
    foreach (str_split($data) as $ch) $bits .= str_pad(decbin(ord($ch)), 8, '0', STR_PAD_LEFT);
    $out = '';
    foreach (str_split($bits, 5) as $chunk) {
        $chunk = str_pad($chunk, 5, '0', STR_PAD_RIGHT);
        $out .= $alphabet[bindec($chunk)];
    }
    return $out;
}

function totp_base32_decode(string $b32): string {
    $alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
    $b32 = strtoupper(preg_replace('/[^A-Z2-7]/i', '', $b32));
    $bits = '';
    foreach (str_split($b32) as $ch) {
        $pos = strpos($alphabet, $ch);
        if ($pos === false) continue;
        $bits .= str_pad(decbin($pos), 5, '0', STR_PAD_LEFT);
    }
    $bytes = '';
    foreach (str_split($bits, 8) as $byte) {
        if (strlen($byte) < 8) break; // trailing padding bits, not a full byte
        $bytes .= chr(bindec($byte));
    }
    return $bytes;
}

function totp_code_at(string $secretBase32, int $timestamp): string {
    $key = totp_base32_decode($secretBase32);
    $counter = intdiv($timestamp, TOTP_PERIOD);
    $counterBin = pack('N*', 0) . pack('N*', $counter); // 8-byte big-endian counter
    $hash = hash_hmac('sha1', $counterBin, $key, true);
    $offset = ord($hash[strlen($hash) - 1]) & 0x0F;
    $truncated = ((ord($hash[$offset]) & 0x7F) << 24)
        | ((ord($hash[$offset + 1]) & 0xFF) << 16)
        | ((ord($hash[$offset + 2]) & 0xFF) << 8)
        | (ord($hash[$offset + 3]) & 0xFF);
    $code = $truncated % (10 ** TOTP_DIGITS);
    return str_pad((string)$code, TOTP_DIGITS, '0', STR_PAD_LEFT);
}

/** Accepts the current 30s step plus one step either side, so a code
 *  typed right at a boundary (or a phone clock a few seconds off)
 *  still works. */
function totp_verify(string $secretBase32, string $code): bool {
    $code = trim($code);
    if (!preg_match('/^\d{6}$/', $code)) return false;
    $now = time();
    for ($skew = -1; $skew <= 1; $skew++) {
        if (hash_equals(totp_code_at($secretBase32, $now + $skew * TOTP_PERIOD), $code)) return true;
    }
    return false;
}

function totp_provisioning_uri(string $secretBase32, string $accountEmail, string $issuer = 'Prakasa Group ACC'): string {
    $label = rawurlencode($issuer . ':' . $accountEmail);
    $params = http_build_query([
        'secret' => $secretBase32,
        'issuer' => $issuer,
        'algorithm' => 'SHA1',
        'digits' => TOTP_DIGITS,
        'period' => TOTP_PERIOD,
    ]);
    return "otpauth://totp/$label?$params";
}
