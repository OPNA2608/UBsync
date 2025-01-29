#!/usr/bin/env bash

set -euo pipefail
shopt -u nullglob

# Adjustable settings

GETTEXT_PACKAGE="lomiri-cloudsync-app"
PROJECT_LANGUAGE="c++"
PROJECT_COPYRIGHT="UBports Developers"
declare -a TRANSLATION_FILETYPES=(
    "*.c"
    "*.h"
    "*.cpp"
    "*.hpp"
    "*.qml"
    "*.js"
)
declare -a TRANSLATION_KEYWORDS=(
    "_"
    "_:1,2"
    "N_"
    "N_:1,2"
    "tr"
    "tr:1,2"
)

# Programm

HERE="$(realpath "$(dirname "${0}")")"
SRC="$(dirname "${HERE}")"

# Built-in
SEARCH_COMMAND="command -v"

# provides nicer feedback, in case something's missing
if ${SEARCH_COMMAND} "which" > /dev/null; then
    SEARCH_COMMAND="$(${SEARCH_COMMAND} which)"
fi

INTLTOOL_UPDATE="$(${SEARCH_COMMAND} "intltool-update")"
FIND="$(${SEARCH_COMMAND} "find")"
SED="$(${SEARCH_COMMAND} "sed")"
SORT="$(${SEARCH_COMMAND} "sort")"

cd "${HERE}"

### Makefile.in.in
echo "Writing Makefile.in.in"

MAKEININ_CONTENTS="XGETTEXT_KEYWORDS=--language ${PROJECT_LANGUAGE} --copyright-holder='${PROJECT_COPYRIGHT}'"
for TRANSLATION_KEYWORD in "${TRANSLATION_KEYWORDS[@]}"; do
    MAKEININ_CONTENTS="${MAKEININ_CONTENTS} --keyword='${TRANSLATION_KEYWORD}'"
done
echo "${MAKEININ_CONTENTS}" > Makefile.in.in

### POTFILES.in
echo "Writing POTFILES.in"

declare -a FIND_ARGS=(
    "${SRC}"
    -name "${TRANSLATION_FILETYPES[0]}"
)
for i in "${!TRANSLATION_FILETYPES[@]}"; do
    # Skip first one, already added
    if [[ "${i}" -eq 0 ]]; then
        continue
    fi

    FIND_ARGS+=(
        -or
        -name "${TRANSLATION_FILETYPES["${i}"]}"
    )
done

${FIND} "${FIND_ARGS[@]}" | ${SED} -e "s@^${SRC}/@@g" | ${SORT} > POTFILES.in

### POT
echo "Updating template ${GETTEXT_PACKAGE}.pot"

${INTLTOOL_UPDATE} --pot "${HERE}/${GETTEXT_PACKAGE}.pot" --gettext-package "${GETTEXT_PACKAGE}"

### POs
for POPATH in "${HERE}"/*.po; do
    POLANG="$(basename "${POPATH}" ".po")"

    echo "Updating translation ${POLANG}"

    ${INTLTOOL_UPDATE} --dist "${POLANG}" --gettext-package "${GETTEXT_PACKAGE}"
done
