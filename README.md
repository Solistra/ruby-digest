
Ruby Digest
=============================================================================
[![Status](https://travis-ci.org/Solistra/ruby-digest.svg?branch=master)][ci]
[ci]: https://travis-ci.org/Solistra/ruby-digest

Summary
-----------------------------------------------------------------------------
  Ruby Digest aims to provide pure-Ruby implementations of the digest objects
provided by the MRI Ruby 'digest' standard library (originally written as
native C extensions). At present, Ruby Digest accurately implements the
`MD5`, `SHA1`, and `SHA256` hashing algorithms, the Bubble Babble encoding,
and the `HMAC` keyed-hash message authentication code.

  Ruby Digest has been provided primarily for Ruby environments which do not
have access to native extensions for any reason (notable examples include
the RPG Maker series and SketchUp Make).

Notes
-----------------------------------------------------------------------------
  While Ruby Digest aims to provide a reasonable, pure-Ruby alternative to
the MRI Ruby 'digest' standard library, there are a few notable classes
missing -- namely the `RMD160`, `SHA384`, and `SHA512` classes.

License
-----------------------------------------------------------------------------
  Ruby Digest is free and unencumbered software released into the public
domain.

