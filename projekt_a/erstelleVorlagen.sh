#!/bin/bash

mkdir -p  _templates

touch _templates/datei-1.txt
touch _templates/datei-2.pdf
touch _templates/datei-3.doc

mkdir -p _schulklassen

schueler_namen=("Müller" "Schmidt" "Schneider" "Fischer" "Weber" "Meyer" "Wagner" "Becker" "Schulz" "Hoffmann" "Schäfer" "Koch")

for klasse in M122-AP22b M122-AP22c M122-APd; do
  datei="_schulklassen/${klasse}.txt"
  touch $datei
  for name in "${schueler_namen[@]}"; do
   echo $name >> $datei
  done
 done

echo "es ist fertig"

