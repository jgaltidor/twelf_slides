# Twelf Tutorial Slides

LaTeX (Beamer) source for a slide presentation by John Altidor on the [Twelf](https://twelf.org/) proof assistant. It walks through the Twelf encoding of *MiniLang*, a small language of numbers and strings, and its proofs of type safety.

**Download the PDF:** [twelf_slides.pdf](https://github.com/jgaltidor/twelf_slides/releases/latest/download/twelf_slides.pdf) (latest release; earlier versions are on the [Releases](https://github.com/jgaltidor/twelf_slides/releases) page).

The slides accompany two other repositories:

- [jgaltidor/typetheory_paper](https://github.com/jgaltidor/typetheory_paper): the tutorial paper that defines MiniLang and its type safety proofs
- [jgaltidor/twelf_tutorial](https://github.com/jgaltidor/twelf_tutorial): the full Twelf encoding of MiniLang

[jgaltidor/typetheory_slides](https://github.com/jgaltidor/typetheory_slides) holds the companion slides on type theory.

**Status:** these slides were written in 2013–2016 and corrected in October 2026 to match the paper and the current Twelf code; the Twelf output they quote was checked against current Twelf. Where they differ, the paper is authoritative.

## Building

You need a LaTeX distribution that provides `pdflatex` and Beamer, such as TeX Live or MacTeX.

```sh
make            # builds twelf_slides.pdf
make clean      # removes auxiliary build files
make distclean  # also removes twelf_slides.pdf
```

For a reproducible build, use the pinned toolchain in `Dockerfile` (a TeX Live 2026 snapshot, pinned by digest; the same image as typetheory_paper and the dissertation). The slides build with it with no LaTeX warnings:

```sh
docker build -t twelf-slides-tex .
docker run --rm -v "$PWD":/workdir twelf-slides-tex          # runs make
docker run --rm -v "$PWD":/workdir twelf-slides-tex make clean
```

`.devcontainer/` opens the same image in VS Code, with LaTeX Workshop set to build with `make`. It also installs Claude Code (the VS Code extension and the `claude` CLI), whose login and settings persist in a Docker volume.

Spell checking uses `cspell.json` with the project word list `project-words.txt` (names, jargon, and LaTeX identifiers); add legitimate new terms there rather than ignoring warnings. Check from the command line with `npx cspell "**/*.tex"`, or in Docker:

```sh
docker run --rm -v "$PWD":/w -w /w node:22-slim npx -y cspell@8 "**/*.tex"
```

It should report 0 issues. In the devcontainer, Code Spell Checker reports spelling and LTeX+ checks grammar; LTeX+'s own spelling rule is disabled so there is a single source of spelling warnings.

## Releasing

The PDF is published as a GitHub Release asset, not committed (build outputs are gitignored). Releases are built with the pinned toolchain in `Dockerfile` (`docker build -t twelf-slides-tex .`). To publish a new version:

```sh
git tag -a v1.1 -m "Twelf tutorial slides v1.1"
git push origin v1.1
git clone --branch v1.1 . /tmp/twelf_slides-release     # build from a clean checkout of the tag
docker run --rm -v /tmp/twelf_slides-release:/workdir twelf-slides-tex
gh release create v1.1 /tmp/twelf_slides-release/twelf_slides.pdf --title "Twelf tutorial slides v1.1" --notes "..."
```

Keep the asset named `twelf_slides.pdf`: the README above and the [twelf_tutorial](https://github.com/jgaltidor/twelf_tutorial) README link to `releases/latest/download/twelf_slides.pdf`, which always serves the newest release.

## License

The slides (their text and LaTeX source) are copyright John Altidor and licensed under the [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/) (CC BY 4.0); see [`LICENSE`](LICENSE). You may share and adapt them, including commercially, as long as you give appropriate credit.

Two images are not the author's and are not covered by this license:

- `tamefj_lemma.png` is a screenshot of part of the type soundness proof of the TameFJ calculus, from the extended version of Nicholas Cameron, Sophia Drossopoulou, and Erik Ernst, "[A Model for Java with Wildcards](https://doi.org/10.1007/978-3-540-70592-5_2)" (ECOOP 2008).
- `mediumelf.png` is the Twelf logo, from the Twelf project.
