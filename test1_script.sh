#!/bin/bash

#exit code 0 以外を指定すると即座にexit(変なコードが出たら止まる）
set -o errexit

#未定義の変数を利用するとエラーメッセージを出してexit(環境変数など指定していないと止まる）
set -o nounset

#xtraceで実行ログの出力
set -x


sample1=$1

#bwa mem でfastqアラインメント
bwa/bwa mem Homo_sapiens_assembly38.fasta sequence1.fastq sequence2.fastq > ${sample1}.sam

#samtoolsでsamからbamへ
samtools-1.16.1/samtools view -bS ${sample1}.sam > ${sample1}.bam

#bamファイルのsort
samtools-1.16.1/samtools sort -@4 ${sample1}.sam > ${sample1}.sort.bam

#baiファイルの作成
samtools-1.16.1/samtools index ${sample1}.sort.bam

#Duplicatesリードの除去
gatk-4.2.0.0/gatk  MarkDuplicates   -I {$sample1}.sort.bam   -M metrics.txt   -O ${sample1}.MarkDup.bam --CREATE_INDEX
