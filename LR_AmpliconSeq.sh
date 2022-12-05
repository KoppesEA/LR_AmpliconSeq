#!/bin/bash
#
#SBATCH -N 1 
#SBATCH -t 1-00:00
#SBATCH -J LR_amplicon
#SBATCH --output=minimap2Clair3-%A_%a.out
#SBATCH --cpus-per-task=4
#SBATCH --mem=24g

module load minimap2/2.24
module load gcc/8.2.0
module load samtools/1.14 ##note clair 3 dependencies is 1.15
module load clair3/0.1-r12

inFolder=./raw_amplicon_fastq/
outFolder=./phased_amplicons
refGenome=./Chr17Ref/Homo_sapiens.GRCh38.dna.chromosome.17.fa

rm -rf $outFolder/*
rmdir $outFolder
mkdir $outFolder

for fastq_file in ${inFolder}/*.fastq
do
	echo $fastq_file	
	samplename=`basename $fastq_file .fastq`
	echo $samplename
	outDir=$outFolder/$samplename
	echo $outDir
	rm -r $outDir
	mkdir $outDir
	minimap2 -a ${refGenome}.gz $fastq_file > $outDir/${samplename}.sam
	samtools view -b -o $outDir/${samplename}.bam $outDir/${samplename}.sam 
	samtools sort -O BAM -o $outDir/${samplename}_sorted.bam $outDir/${samplename}.bam 
	samtools index -b $outDir/${samplename}_sorted.bam 
	run_clair3.sh \
	--bam_fn=$outDir/${samplename}_sorted.bam \
	--ref_fn=$refGenome \
	--output=$outDir \
	--threads=4 \
	--platform=ont \
	--model_path=./r941_prom_sup_g5014/ \
	--enable_phasing
	echo $samplename >> $outFolder/mygene_phaseSummary.vcf
	gunzip -c $outDir/phased_merge_output.vcf.gz >> $outFolder/mygene_phaseSummary.vcf

	done
