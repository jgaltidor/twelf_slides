# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

LaTeX Beamer slides (a Twelf tutorial) that walk through the Twelf encoding of *MiniLang* and its type safety proofs. There is no code to test; the only build product is `twelf_slides.pdf`.

The slides depend on two sibling repositories, and must stay consistent with them:

- [typetheory_paper](https://github.com/jgaltidor/typetheory_paper): the tutorial paper. **Where the slides and the paper differ, the paper is authoritative.**
- [twelf_tutorial](https://github.com/jgaltidor/twelf_tutorial): the Twelf code the slides quote. Code, names (e.g. `of/nat`, `E1~>E1'`), file/line locations in error messages (e.g. `preservation.elf:98.8`), and Twelf output on the slides should match what current Twelf prints when run on that code. The slides also link to paths in that repo (e.g. `exercises/numsubtype`).

## Building

```sh
make            # runs pdflatex twice (needed for frame numbers / total frame count)
make clean      # removes auxiliary files
make distclean  # also removes twelf_slides.pdf
```

Pinned toolchain: `docker build -t twelf-slides-tex .` then `docker run --rm -v "$PWD":/workdir twelf-slides-tex` (runs `make`). The `Dockerfile` pins the same TeX Live 2026 image, by digest, as typetheory_paper and the dissertation; `.devcontainer/` uses it too, and its LTeX+ settings list the deck's prose macros. Release PDFs are built with this image.

To check a change, build and look in `twelf_slides.log` for warnings and `Overfull \hbox` / `Overfull \vbox` messages: the deck currently builds with no LaTeX or font warnings and no overfull boxes, so any such message is new (an overfull box means content spills off a slide). `\code` and the `\infer` rule labels wrap their text in `\text{...}` so they work inside math; keep size changes inside `\text` rather than using `\begin{small}` in math.

Spell check, configured as in typetheory_paper: `docker run --rm -v "$PWD":/w -w /w node:22-slim npx -y cspell@8 "**/*.tex"` must report 0 issues. Add legitimate new terms to `project-words.txt`.

CI: `.github/workflows/build.yml` runs the Docker build, then fails if `twelf_slides.log` has a warning or an overfull or underfull box, or if cspell reports an issue. Keep the build clean, or the push turns red; if a new message is genuinely expected, change the check in the workflow and the note here together. Dependabot (`.github/dependabot.yml`) opens monthly pull requests to bump the SHA-pinned GitHub Actions.

Grammar check: LTeX+ (in the devcontainer) skips `alltt` code blocks and its arrow rule. It still reports 7 known false positives, mostly a frame title read together with the first bullet ("Blocks: Blocks") and the deliberate repetition of "Holes" on the Higher-Order Terms slide; anything else it reports is new.

## Structure

- `twelf_slides.tex`: the whole deck. Each `\section` is a topic; slides are `frame` environments.
- `mymacros.tex`: `\input` by the deck; holds packages and macros. Macros used throughout the slides:
  - `\code{...}`: small typewriter text for inline Twelf.
  - `\cemph{...}`: red emphasis for code or math.
  - `\gtrm{...}` / `\utrm{...}` (and `...big` variants): blue for ground Twelf terms, orange for non-ground terms (used in the ground-checking slides).
  - `\emph` is redefined in `twelf_slides.tex` as bold italic.
- Twelf code blocks use `verbatim` (no markup) or `alltt` (when parts need `\cemph` etc.). A frame containing `verbatim` must be declared `\begin{frame}[containsverbatim]`.
- `tamefj_lemma.png` and `mediumelf.png` are third-party images, excluded from the CC BY 4.0 license (see README).

## Releasing

The PDF is not committed (build outputs are gitignored); it's published as a GitHub Release asset built with this repo's pinned `Dockerfile` image. Follow the steps in the README's "Releasing" section. The asset must stay named `twelf_slides.pdf`, because this README and twelf_tutorial's README link to `releases/latest/download/twelf_slides.pdf`.
