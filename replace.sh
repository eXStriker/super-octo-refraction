sed -i 's/\<'$1'\>/'$2'/' $(grep -lwr --include="*.asm" --include="*.ctf" --exclude-dir="extras" --exclude-dir="crowdmap" --exclude-dir="utils" --exclude-dir=".git" --exclude-dir="alignedconstants" --exclude-dir="animatedgifs" --exclude-dir="backpics" --exclude-dir="lzcomp" --exclude-dir="mockups" --exclude-dir="patch" *.asm)
# $1: phrase to find
# $2: phrase to replace $1
