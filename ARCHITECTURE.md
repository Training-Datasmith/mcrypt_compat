# Architecture: mcrypt_compat

## Purpose

A polyfill for the `mcrypt_*` functions removed in PHP 7.2. Provides PHP 5.x/7.x compatibility by reimplementing the mcrypt API on top of `openssl_*` or `libsodium` for supported ciphers.

## Directory Structure

```
lib/
  mcrypt.php   — All mcrypt_* function polyfills (mcrypt_encrypt, mcrypt_decrypt, etc.)
```

## Key Design Decisions

- **Guard-wrapped**: Functions are only defined if `!function_exists(...)`, so including the file on PHP 5.6 (which has native mcrypt) is a no-op
- **openssl backend**: Uses `openssl_encrypt` / `openssl_decrypt` under the hood with equivalent cipher/mode mappings
- **Cipher mapping**: A lookup table maps mcrypt cipher+mode strings (e.g., `MCRYPT_RIJNDAEL_128` + `MCRYPT_MODE_CBC`) to OpenSSL cipher names (e.g., `aes-128-cbc`)

## Security Notes

- **ECB and CBC modes are not authenticated** — do not use for new code; migrate to `sodium_crypto_secretbox` or AES-GCM
- This library exists purely for backwards compatibility; new code should use PHP 8's `sodium_*` or `openssl_*` directly

## Extension Points

- No extension points; this is a drop-in shim intended to be transparent
