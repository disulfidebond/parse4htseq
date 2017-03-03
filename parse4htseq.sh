#!/bin/sh

let j=1
let PCOUNT=0
echo "Starting parse"
for i in *.htseq-union.txt ; do
  echo "parsing $i"
  if (($j < 2)) ; then
    NCT=$(sed -n "/follows/{=; q;}" $i)
    # grep -B3 BB0001 $i
    let NCT_L0=$NCT+1
    let NCT_L1=$NCT+2
    let NCT_L2=$NCT+3
    L0=$(sed "${NCT_L0}q;d" $i)
    L1=$(sed "${NCT_L1}q;d" $i)
    L2=$(sed "${NCT_L2}q;d" $i)
    echo $L0
    echo "$L1 <- parsing will start here"
    echo $L2
    read -p "Ready to parse Cluster Output.  Continue [Y/n]? " PROMPT
    if [[ "$PROMPT" = 'y' || "$PROMPT" = 'Y' ]] ; then
      let PCOUNT=$NCT_L1
    else
      echo "Exiting..."
      exit 1
    fi
  fi
  NM=$(echo $i | cut -d'-' -f5)
  tail -n +${PCOUNT} $i | head -n -5 > ${NM}.htseqout.txt
  echo "Header and footer look like:"
  head ${NM}.htseqout.txt ; echo "" ; tail ${NM}.htseqout.txt
  echo ""
  sleep 1
  let j=$j+1
done
