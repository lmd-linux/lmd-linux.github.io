#! /bin/bash

git pull -r

TESTING_PKGS=$(find pool/testing/* -type f)
if [[ -z "${TESTING_PKGS}" ]]; then
    echo "Nothing to stabilize"
    exit
fi

for PKG in ${TESTING_PKGS}; do
    mv ${PKG} ${PKG/\/testing\//\/stable\/}
done

ALL_PKGS=$(for PKG in $(find pool/stable/* -type f); do sed 's/^\(.*\/[^_]*\).*/\1/' <<< ${PKG}; done | sort -u )

for PKG in ${ALL_PKGS}; do
    rm -f $(ls -1 ${PKG}_* | head -n -1)
done

git add .

MESSAGE=$(mktemp)
echo "Stabilise:" > ${MESSAGE}
for PKG in ${TESTING_PKGS}; do
    if [[ -f ${PKG/\/testing\//\/stable\/} ]]; then
        echo "    ${PKG}" >> ${MESSAGE}
    fi
done

if [[ $(cat ${MESSAGE} | wc -l) -gt 1  ]]; then
    git commit -F ${MESSAGE}
fi

rm -f ${MESSAGE}
