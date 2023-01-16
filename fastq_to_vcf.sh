#!/bin/bash

#exit code 0 以外を指定すると即座にexit(変なコードが出たら止まる）
set -o errexit

#未定義の変数を利用するとエラーメッセージを出してexit(環境変数など指定していないと止まる）
set -o nounset

#xtraceで実行ログの出力
set -x


sample1=$1
read1_fastq=$2
read2_fastq=$3
ref_fasta=$4
#bwa mem でfastqアラインメント
bwa mem -R "@RG\tID:L\tSM:"${sample1}"\tPL:illumina\tLB:lib1\tPU:unit1" -t 16\ -M ${ref_fasta} ${read1_fastq} ${read2_fastq} > ${sample1}.sam


#bamファイルのsort
samtools sort -@4 ${sample1}.sam > ${sample1}.sort.bam

#baiファイルの作成
samtools index ${sample1}.sort.bam

#Duplicatesリードの除去
gatk  MarkDuplicates   -I ${sample1}.sort.bam   -M metrics.txt   -O ${sample1}.MarkDup.bam --CREATE_INDEX

#HaplotypeCallerの実施
gatk HaplotypeCaller -R ${ref_fasta} -I ${sample1}.MarkDup.bam -O ${sample1}.output.g.vcf.gz -ERC GVCF

#vcfに変換
gatk GenotypeGVCFs 
　　--variant ${sample1}.haplotypecaller1.g.vcf 
　　-R ${ref_fasta} 
　　-O ${sample1}.haplotypecaller.vcf
