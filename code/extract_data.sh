outdir=/scVI/scVI-data
mkdir -p $outdir/reorganized/originals
unzip /scVI/scVI-reproducibility/additional/data.zip PBMC/*   -d $outdir/reorganized/originals
unzip /scVI/scVI-reproducibility/additional/data.zip RETINA/* -d $outdir/reorganized/originals
unzip /scVI/scVI-reproducibility/additional/data.zip HEMATO/* -d $outdir/reorganized/originals

mkdir -p $outdir/reorganized/originals/CORTEX
wget -v -O $outdir/reorganized/originals/CORTEX/expression_mRNA_17-Aug-2014.txt https://storage.googleapis.com/linnarsson-lab-www-blobs/blobs/cortex/expression_mRNA_17-Aug-2014.txt

