#FILES=./colorectal_data/GDC/*.maf
#FILES=TCGA.COAD.combined.somatic.maf
FILES=../endomentrial_data/TCGA.UCEC.combined.somatic.maf
#FILES=TCGA.LUAD.combined.somatic.maf
#g=hg38
g=../GRCh38.d1.vd1
#window size, first input argument
w=$1
#p-value threshold
p=1.0
#motif type, second input argument
pur=$2
per=$3
#loop through the files
for f in $FILES
do
   if [ -f "$f" ]; then
	#echo "Processing $f file..."
	#echo "Window size $w"

	for ((k=1; k<=13; k++)) 
	do
		mut="[G>T]"
        	st="AG"
		Rstr=$per
		#create string of motifs into which to insert the mutation
		for ((r=1; r<=$k; r++))
		do
			Rstr=$Rstr$pur
                done
		Rstr=$Rstr$per
		#echo $Rstr
		for ((j=2; j<=$k+2; j++)) 
		do
			#construct motif before mutation (string, start, length)
			str=${Rstr:0:$j-1}
			motifin=$str$mut
                        stin=$str$st
			#construct motif after mutation (string, start, length)
			str=${Rstr:$j-1:$k+2-$j+2}
			motifin=$motifin$str
                        stin=$stin$str
			#echo "Processing $motifin"
			echo $motifin	
		
			#run mutagene motif search
			#fname="./output/"$stin"_"$w".txt"
			#fbedname="./output_beds/matches_"$stin"_"$w".bed"
			#echo "mutagene -m $motifin -w $w -t $p -o $fname --save-motif-matches $fbedname"
			#mutagene -vv motif -i $f -f MAF -g $g -m $motifin -w $w -t $p -o $fname --save-motif-matches $fbedname	
		done
	done
fi
done
