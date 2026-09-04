# Annex — `harness-v1` Canonicalisation Contract

**Status:** Normative for Engineering Harness v0.3.0  
**Canonicalisation identifier:** `harness-v1`

## 1. Scope

This contract defines canonical bytes for Harness-governed YAML/JSON objects before SHA-256 hashing. It does not transform arbitrary manifest-declared source files, which are hashed as exact raw bytes unless their role explicitly identifies them as governed Harness documents.

## 2. Governed YAML input

Parsers shall accept YAML 1.2.2 syntax only through this restricted subset:

- one document only;
- UTF-8 without BOM;
- mappings with string keys only;
- sequences;
- Unicode strings;
- lowercase `true`, `false`, `null` typed scalars;
- signed base-10 integers matching `0|-?[1-9][0-9]*`;
- comments and YAML block/flow presentation syntax may occur but do not survive parsing.

Prohibited:

- anchors, aliases and merge keys;
- explicit/custom tags;
- duplicate raw mapping keys;
- non-string mapping keys;
- floats/exponents, NaN, infinities;
- hex/octal/base-prefixed integers;
- plus-prefixed integers;
- negative zero;
- multiple documents;
- surrogate code points;
- BOM.

Integers must be in `[-9223372036854775808, 9223372036854775807]`.

A parser shall not coerce unsupported scalar spellings. If an unsupported YAML feature is encountered, return `YAML_UNSUPPORTED_FEATURE`.

Governed JSON input follows RFC 8259, must be UTF-8 without BOM, must contain one root value, must reject duplicate object keys, and is restricted to the same value model and signed-64-bit integer range. JSON fractional/exponent numbers are prohibited.

## 3. Normalisation

For every string value and mapping key:

1. replace CRLF with LF;
2. replace remaining CR with LF;
3. normalise Unicode to NFC.

After normalising mapping keys, keys must remain unique. A collision is `CANONICALISATION_KEY_COLLISION`; no digest is produced.

Absent object members remain absent. Explicit `null` remains present as `null`. Schema defaults are never inserted before hashing.

## 4. Canonical JSON

Canonical output is a single JSON value encoded as UTF-8 without BOM and without insignificant whitespace.

### Objects

- keys are their normalised strings;
- sort keys ascending by Unicode scalar-value sequence;
- emit `:` between key and value and `,` between members with no spaces.

### Arrays

Preserve order unless Section 5 declares a pre-sort for a generated set-like collection.

### Strings

Use double quotes. Escape exactly:

| Character | Encoding |
|---|---|
| `"` | `\"` |
| `\\` | `\\\\` |
| U+0008 | `\b` |
| U+0009 | `\t` |
| U+000A | `\n` |
| U+000C | `\f` |
| U+000D | `\r` |
| other U+0000–U+001F | lowercase `\u00xx` |

All other Unicode scalar values, including U+2028/U+2029, are emitted directly in UTF-8.

### Integers

Emit minimal decimal form: optional `-` followed by digits, no leading zeros except `0`, no `+`, no exponent.

### Booleans/null

Emit exactly `true`, `false`, `null`.

## 5. Required deterministic pre-sorts

Only these generated collections are pre-sorted:

| Contract / field | Sort key |
|---|---|
| Project Pack fingerprint `entries` | `path` |
| Engineering controls `controls` | `id` |
| Engineering profile `technology` | technology ID |
| Engineering profile `configuration` | `control` |
| Engineering profile `overrides` | override ID |
| Validation subject `upstream` | `type`, then `baseline_id` |
| Validation subject `artifacts` | `path` |
| Validation evidence `controls` | `control` |
| Validation/control-result `issues` | `code`, then `location` with absent after present values, then `message` |
| Approval candidate `upstream` | `type`, then `baseline_id` |
| Approval candidate `artifacts` | `path` |
| Project AI Policy `controls` | `control` |
| Generated issues inside any content-addressed object | same issue ordering above |

No other array is sorted by the canonicaliser.

## 6. Repository paths

Path normalisation is a schema/semantic validation step before canonical JSON. Canonical governed paths:

- are relative to project root or the schema-defined sub-boundary;
- use `/` only;
- contain no empty, `.` or `..` segments;
- are not symlinks when resolved as governed artefacts.

The canonicaliser does not repair or rewrite a non-canonical path.

## 7. Self-digest exclusion

Hash preimages omit exactly one schema-defined self-digest field where applicable:

| Object | Excluded field |
|---|---|
| Project Pack fingerprint subject | none (digest is stored outside the subject) |
| Engineering controls/resolution | `binding.digest` |
| Validation subject | `validation_subject.binding.digest` |
| Validation evidence | `validation.binding.digest` |
| Approval candidate | `candidate.binding.digest` |
| Human decision/approval evidence | `approval.binding.digest` |
| Project AI Policy | `ai_policy.binding.digest` |
| Baseline | `baseline.binding.digest` |

Nested/upstream digests are retained.

## 8. Hash

`digest = "sha256:" + lowercase_hex(SHA256(canonical_utf8_bytes))`

## 9. Conformance

`canonicalisation-vectors.json` is authoritative. Every vector provides the exact preimage object, excluded field, canonical JSON, UTF-8 hex and expected digest. An implementation that differs on any vector is non-conformant.
