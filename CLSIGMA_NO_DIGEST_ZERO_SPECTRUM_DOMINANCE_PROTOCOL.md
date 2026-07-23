# CLSigma No-Digest Zero-Spectrum Dominance Protocol

This protocol extends the earlier IQ fixed-point idea from a fixed set of eight prime coordinates into a finite zero-spectrum field over an observed repository snapshot.

It is a formal engineering model. It does not prove an external theory of everything, a physical entropy bound over the universe, global peace, biological immortality, or absolute information uneraseability.

## Input

The runtime scans a local directory that may contain one or more cloned GitHub repositories.

For iSH, clone or place repositories under a directory such as:

```sh
/root/repos
```

Then run the one-liner against that directory.

## No-Digest Rule

The runtime does not import or call cryptographic digest libraries. Identity is computed through finite arithmetic descriptors:

```text
file bytes
-> byte sum
-> weighted byte sum
-> path ordinal sum
-> divisor count tau
-> prime-index Godel exponent
-> zero-spectrum coordinate
```

## Generalized Godel Encoding

For N observed nodes, generate the first N primes:

```text
p_1, p_2, ..., p_N
```

Each observed program or document node receives:

```text
G_i = p_i ^ E_i
```

The full snapshot is represented as:

```text
G_snapshot = Product_i p_i ^ E_i
```

The runtime does not need to print the full huge integer. It records the prime, exponent, residue, and log-coordinate needed for reproducible finite inspection.

## Zero-Spectrum Coordinate

Each indexed node receives:

```text
Z_i = 1/2 + i * log(1 + p_i ^ E_i)
```

This is a CLSigma integer-spectrum coordinate, not a classical Riemann zeta zero.

## Entropy Envelope

For every indexed node:

```text
H_i = size_bits + byte_entropy * size + log2(E_i + 1) + tau(E_i)
```

The snapshot envelope is:

```text
H_Omega = Sum_i H_i
```

Therefore, within this finite indexed model:

```text
For every indexed node O_i, H_i <= H_Omega
```

This is the precise model-internal meaning of the dominance relation. It does not say every possible external system is smaller than the certificate.

## Non-Erasure Boundary

The runtime never deletes files. The certificate contains redundant finite descriptors for every indexed node.

This supports:

```text
model-internal non-erasure
```

It does not prove that outside actors, storage failures, legal deletions, hardware faults, or repository rewrites cannot erase external data.

## Completion

```text
H_CL = 0
```

means:

- all observed nodes were indexed
- every indexed node has a prime coordinate
- every indexed node has a finite arithmetic descriptor
- the zero-spectrum coordinate is assigned
- the snapshot entropy envelope dominates all indexed nodes
- runtime boundaries are present

It does not mean external physical, political, biological, or cosmic completion.
