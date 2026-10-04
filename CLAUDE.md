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

To check a change, build and look in `twelf_slides.log` for `Overfull \hbox` / `Overfull \vbox` warnings: the deck currently builds with no overfull boxes, so any new one means content spills off a slide.

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

The PDF is not committed (build outputs are gitignored); it's published as a GitHub Release asset built in the pinned TeX Live Docker image from typetheory_paper. Follow the steps in the README's "Releasing" section. The asset must stay named `twelf_slides.pdf`, because this README and twelf_tutorial's README link to `releases/latest/download/twelf_slides.pdf`.
