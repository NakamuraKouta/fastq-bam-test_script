# Abstract 
This work shows the process of creating a bam file and vcf from fastq.
Three tools are used: bwa, samtools, and gatk.
The final file created is VCF.
The gVCF contains records for all positions with and without mutation detection.

##Procedure
・Align fastq with bwa to create a sam file.
 
>bwa mem -R "@RG\tID:L\tSM:"${sample1}"\tPL:illumina\tLB:lib1\tPU:unit1" -t 16\ 
> -M ${ref_fasta}
>   ${read1_fastq} 
>   ${read2_fastq}  
>   > ${sample1}.sam
 
${sample1} : sample name
${ref_fasta} : Specify the location where the reference fasta　(ex ./input/Homo_sapiens_assembly38.fasta)
${read1_fastq},{read2_fastq} : Specify the location where the read fastq (ex ./input/read1_fastq)

・Sort the sam file using samtools and create a bam file.

>samtools sort -@4 ${sample1}.sam > ${sample1}.sort.bam
 
>samtools index ${sample1}.sort.bam
 
※Specify the location where files are located.

・Remove duplicates from the bam file using GATK MarkDuplication.
 
>gatk  MarkDuplicates   -I ${sample1}.sort.bam   -M metrics.txt   -O ${sample1}.MarkDup.bam --CREATE_INDEX
-I : input file
-O : output 


・Mutation detection using GATK HaplotypeCaller
>gatk HaplotypeCaller -R ${ref_fasta} -I ${sample1}MarkDup.bam -O {sample1}.output.g.vcf.gz -ERC GVCF

Specify the name of the input and output file


・gVCF to vcf
>gatk GenotypeGVCFs --variant ${sample1}.haplotypecaller1.g.vcf -R　${ref_fasta} -O ${sample1}.haplotypecaller.vcf

Specify the name of the input and output file

※For multiple samples

>gatk GenotypeGVCFs \
　　--variant haplotypecaller1.g.vcf \
　　--variant haplotypecaller2.g.vcf \
　　--variant haplotypecaller3.g.vcf \
　　-R ${ref_fasta} \
　　-O ${sample1}.haplotypecaller.vcf
