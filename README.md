# LR_AmpliconSeq
minimap2 / clair3 amplicon haplotyping

## Step 1: Download, and index Reference for Chr of interest (H.Sap Chr17 in this case)
mkdir Chr17Ref
```
wget -O ./Chr17Ref/Homo_sapiens.GRCh38.dna.chromosome.17.fa.gz http://ftp.ensembl.org/pub/release-107/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.chromosome.17.fa.gz
cd ./Chr17Ref/
module load gcc/8.2.0
module load samtools/1.14
gunzip -c Homo_sapiens.GRCh38.dna.chromosome.17.fa.gz > Homo_sapiens.GRCh38.dna.chromosome.17.fa
samtools faidx Homo_sapiens.GRCh38.dna.chromosome.17.fa
cd ..
```

## Step 2: Download Clair3 and models
```
wget -O ./r941_prom_sup_g5014.tar.gz  http://www.bio8.cs.hku.hk/clair3/clair3_models/r941_prom_sup_g5014.tar.gz
gunzip r941_prom_sup_g5014.tar.gz

wget -O ./r941_prom_hac_g360+g422.tar.gz  http://www.bio8.cs.hku.hk/clair3/clair3_models/r941_prom_hac_g360+g422.tar.gz
gunzip ./r941_prom_hac_g360+g422.tar.gz

wget -O ./clair3_models.tar.gz http://www.bio8.cs.hku.hk/clair3/clair3_models/clair3_models.tar.gz
tar -xvf ./clair3_models.tar.gz

wget -O ./clair3.py https://github.com/HKU-BAL/Clair3/blob/main/clair3.py
wget -O ./run_clair3.sh https://github.com/HKU-BAL/Clair3/blob/main/run_clair3.sh
module load python/anaconda3.9-2021.11

# clone Clair3
git clone https://github.com/HKU-BAL/Clair3/blob/main/clair3.py
```
## Step3: Use LR_AmpliconSeq.sh to run Minimap2 and Clair3 for SNP dection and phasing
```
sbatch LR_AmpliconSeq.sh
```
See file ACADVL_phaseSummary.VCF for output summary, ignore SNPs that fall outside the ACADVL genomic region (17:)
