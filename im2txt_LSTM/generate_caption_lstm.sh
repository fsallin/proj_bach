#!/bin/bash

#SBATCH -J caption_LSTM
#SBATCH -o output/caption_LSTM.o%j
#SBATCH --constraint="V5|V6"
#SBATCH --partition=shared-gpu
#SBATCH --time=00:03:00
#SBATCH --gres=gpu:titan:1
#SBATCH --mem=12GB

module load GCC/4.9.3-2.25 OpenMPI/1.10.2 Python/2.7.11 foss/2016a Java/1.8.0_92 CUDA cuDNN tensorflow/1.0.1-Python-2.7.11

# if you need to know the allocated CUDA device, you can obtain it here:
echo $CUDA_VISIBLE_DEVICES

cd ~/proj_bach/
source python_virtual_env/bin/activate
cd im2txt_LSTM/
/opt/bazel/bazel-0.4.4/bazel build -c opt //im2txt/...
srun bazel-bin/im2txt/run_inference \
	--checkpoint_path=im2txt/model/train \
	--vocab_file=$HOME/proj_bach/data/mscoco/word_counts.txt \
	--input_files=$HOME/proj_bach/data/chien.jpg
	#--input_files=im2txt/data/mscoco/raw-data/val2014/COCO_val2014_000000224477.jpg
