#! /bin/bash

git pull -r

echo

TESTING_PKGS=$(find pool/testing/* -type f)
if [[ -z "${TESTING_PKGS}" ]]; then
    echo "Nothing to stabilize"
    exit
fi

for PKG in ${TESTING_PKGS}; do
    echo "Found package ${PKG}"
    mv ${PKG} ${PKG/\/testing\//\/stable\/}
done

echo

ALL_PKGS=$(for PKG in $(find pool/stable/* -type f); do sed 's/^\(.*\/[^_]*\).*/\1/' <<< ${PKG}; done | sort -u )

for PKG in ${ALL_PKGS}; do
    echo ">>> ${PKG}"
    PREFIX=$(ls -1 ${PKG}_* | cut -d '_' -f 1 | head -n 1)
    OLD_VERSIONS=$(ls -1 ${PKG}_* | cut -d '_' -f 2 | sort -V | head -n -1)
    SUFFIX=$(ls -1 ${PKG}_* | cut -d '_' -f 3 | head -n 1)
    if [[ -n "${OLD_VERSIONS}" ]]; then
        for VERSION in ${OLD_VERSIONS}; do
            echo "Deleting ${PREFIX}_${VERSION}_${SUFFIX}"
            rm "${PREFIX}_${VERSION}_${SUFFIX}"
        done
    fi
done

echo

git add .

MESSAGE=
for PKG in ${TESTING_PKGS}; do
    if [[ -f ${PKG/\/testing\//\/stable\/} ]]; then
        if [[ -n "${MESSAGE}" ]]; then
            MESSAGE+=", "
        fi
        MESSAGE+="$(basename ${PKG} .deb)"
    fi
done

if [[ -z "${MESSAGE}" ]]; then
    echo "Nothing to commit?"
    exit
fi
echo "Commit message: Stabilize ${MESSAGE}"

echo

git commit -m "Stabilize ${MESSAGE}"

echo

git --no-pager whatchanged HEAD~..HEAD
