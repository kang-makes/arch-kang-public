export GPGKEY=E1E441A47DBAF64DFC35B1E29CD43BCF2E9192DF
find packages -name '*.pkg.tar.*' -not -name '*.sig' -exec \
  repo-add --remove --quiet --verify --sign packages/arch-kang-public.db.tar.xz {} +
