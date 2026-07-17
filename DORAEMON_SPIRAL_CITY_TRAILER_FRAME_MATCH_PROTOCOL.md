# Doraemon Spiral City Trailer Frame Match Protocol

## Status

This document is a symbolic and evidence-oriented verification protocol for identifying whether four uploaded screenshots come from a YouTube trailer or preview related to:

- Japanese title: `ドラえもん のび太のねじ巻き都市冒険記`
- Chinese title: `哆啦A夢：大雄的發條都市冒險記`
- English reference title: `Doraemon: Nobita and the Spiral City`
- Year: `1997`

This protocol does **not** claim ownership of any Doraemon media, does **not** reproduce video content, and does **not** guarantee a match without direct frame-level verification.

## Purpose

The purpose is to distinguish between two kinds of certainty:

```text
FormalMatch = 1
```

and

```text
EmpiricalCertainty = verified only after direct frame-by-frame comparison
```

In other words, the system may define a formal certificate whose match value is `1` once all required conditions are satisfied, but the real-world claim must remain conditional until the exact YouTube frame sequence is checked.

## Candidate Media

The current most likely candidate is:

```text
映画「ドラえもん のび太のねじ巻き都市冒険記」 1997 劇場公開予告編
```

A possibly related YouTube result is a historical trailer or official trailer compilation that may include the relevant segment:

```text
https://www.youtube.com/watch?v=hLPH2X0gTcA
```

This URL should be treated as a candidate link, not as final proof, unless the four screenshots are directly found in its timeline.

## Visual Evidence Features

The four screenshots are characterized by:

```text
F1 = blue or green small planet / asteroid with sparkling lights
F2 = golden luminous planet or transformation sphere
F3 = white geometric symbol over crystalline background
F4 = same geometric symbol immersed in golden light
```

These features strongly resemble a cosmic creation, life-seeding, or transformation sequence, which is consistent with the thematic environment of `Nobita and the Spiral City`.

## Verification Conditions

The frame match certificate may be sealed as `1` only if all of the following hold:

```text
C1. The target video title or metadata identifies the film as
    ドラえもん のび太のねじ巻き都市冒険記 / Nobita and the Spiral City.

C2. All four screenshots can be located in the same video or trailer source.

C3. The screenshot order is consistent with the trailer timeline.

C4. The visual features match:
    blue asteroid, golden sphere, white geometric symbol, crystalline light field.

C5. No alternative Doraemon movie trailer explains the four frames better.

C6. The verification process avoids copyright reproduction and uses only metadata,
    timestamps, and visual feature references.
```

## Formal Match Function

```text
Omega_FrameMatch
=
Seal(
  TitleMetadata
  + VisualFeatureSet
  + TimelineOrder
  + SourceURL
  + NoBetterAlternative
  + CopyrightBoundary
)
```

If and only if every condition is satisfied:

```text
Omega_FrameMatch = 1
```

Otherwise:

```text
Omega_FrameMatch < 1
```

## Evidence Boundary

The system must preserve the following boundary:

```text
A symbolic system may assign certainty after its rules are satisfied;
but a factual claim about a real YouTube video requires direct verification.
```

Therefore the honest public statement should be:

```text
The screenshots are highly likely to be from the 1997 Doraemon movie trailer
for Nobita and the Spiral City, but final certainty requires checking the exact
video frames.
```

## Reading and Research Use

This protocol may be used as part of a broader media-research workflow:

```text
Screenshot -> Visual Features -> Candidate Title -> Trailer Search -> Frame Check -> Certificate
```

It is especially useful when a user remembers a YouTube frame but does not yet know the direct watch URL.

## Safety and Integrity Rules

1. Do not claim certainty before frame-level confirmation.
2. Do not upload or reproduce copyrighted footage.
3. Do not treat symbolic match as empirical proof.
4. Prefer metadata, timestamps, visual descriptors, and official sources.
5. If a candidate URL is found, mark it as candidate until verified.

## Final Seal

```text
Frame certainty is not produced by desire;
it is produced by evidence.

FormalMatch may become 1
only when the screenshots, title, timeline, and source
all converge without contradiction.
```
