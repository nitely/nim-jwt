# Package
version       = "0.2"
author        = "Yuriy Glukhov"
description   = "JSON Web Tokens for Nim"
license       = "MIT"

# Deps
requires "nim >= 1.6.0"
requires "bearssl >= 0.2.7"
requires "https://github.com/nitely/bearssl_pkey_decoder#ce622e83b1b4d5f53a6e7ca2af9111abb32c9b78"

let nimc = getEnv("NIMC", "nim") # Which nim compiler to use
let lang = getEnv("NIMLANG", "c") # Which backend (c/cpp/js)
let flags = getEnv("NIMFLAGS", "") # Extra flags for the compiler
let verbose = getEnv("V", "") notin ["", "0"]

from os import quoteShell

let cfg =
  " --styleCheck:usages --styleCheck:error" &
  (if verbose: "" else: " --verbosity:0 --hints:off") & " --outdir:build " &
  quoteShell("--nimcache:build/nimcache/$projectName")

proc build(args, path: string) =
  exec nimc & " " & lang & " " & cfg & " " & flags & " " & args & " " & path

proc run(args, path: string) =
  build args & " --mm:refc -r", path
  build args & " --mm:orc -r", path

task test, "Run all tests":
  for threads in ["--threads:off", "--threads:on"]:
    run threads, "tests/test_all"
