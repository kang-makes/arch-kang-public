#!/bin/bash

WD=$(git rev-parse --show-toplevel)
config=$PWD/makepkg.conf

git submodule update --init --remote --recursive

#          1   A.  S...  000000  160000  160000  0000000000000000000000000000000000000000  71e9c4f102c3cebcb5e909f726781d170cafad88 aur-repos/kubelet-bin         # new submodule
#          1   M.  S...  160000  160000  160000  bf56641664d56b954b8e5eaa09fd04ba05387899  71e9c4f102c3cebcb5e909f726781d170cafad88 aur-repos/kubelet-bin         # changes on stage
#          1   .M  SC..  160000  160000  160000  f7fd67d1b678b6da50b39ccdee8e415579d0e1d2  f7fd67d1b678b6da50b39ccdee8e415579d0e1d2 aur-repos/kubernetes-cni-bin  # changed on working area

git status --porcelain=2 | \
while read TR  XY  SUB   MH      MI      MW      HH                                        HI                                       SUBMODULE;                    do

if [ "${SUB:0:1}" == "N" ]; then                                        # Change on a file that is not a submodule
  echo "ERROR: Automatic commiting is only supported with submodules"
  echo "$path is not a submodule and has a change."
  echo "Manual intervention is needed."
  exit 1
fi

if [ "$TR" -neq 2 ]; then                                               # Change is not simply an update
  echo "ERROR: A submodule has been copied, renamed or moved."
  echo "Manual intervention is needed."
  exit 1
fi

if [ "${SUB:1:1}" == "C" ]; then                                        # Submodule is changed.
  cd $WD/$SUBMODULE
  makepkg
  git lfs track "$WD/packages/*"
fi
done

for package in $WD/aur-repos/*; do
  cd $package;
  makepkg --config $config
done

r
