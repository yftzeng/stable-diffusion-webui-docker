#!/usr/bin/env bash

declare -A arr

# models
arr["https://huggingface.co/prompthero/openjourney/resolve/main/mdjrny-v4.safetensors"]="models/Stable-diffusion"
arr+=(["https://huggingface.co/prompthero/openjourney-v2/resolve/main/openjourney-v2.ckpt"]="models/Stable-diffusion")
arr+=(["https://huggingface.co/ckpt/anything-v4.5-vae-swapped/resolve/main/anything-v4.5-vae-swapped.safetensors"]="models/Stable-diffusion")
arr+=(["https://huggingface.co/dreamlike-art/dreamlike-photoreal-2.0/resolve/main/dreamlike-photoreal-2.0.safetensors"]="models/Stable-diffusion")
arr+=(["https://huggingface.co/nuigurumi/basil_mix/resolve/main/Basil_mix_fixed.safetensors"]="models/Stable-diffusion")
arr+=(["https://huggingface.co/Alsebay/Chilloutmix-Ni-fix/resolve/main/Chilloutmix-Ni-fix/Chilloutmix-Ni-prune-fp32-fix.safetensors"]="models/Stable-diffusion")
# vae
arr+=(["https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors"]="models/VAE")
# embeddings
arr+=(["https://huggingface.co/datasets/gsdf/EasyNegative/resolve/main/EasyNegative.safetensors"]="embeddings")

current_directory=$(pwd)

for key in ${!arr[@]}; do
  mkdir -p "${arr[${key}]}"
  cd "${arr[${key}]}"
  echo "Download ${key} to ${arr[${key}]}"
  curl -sLO -C - "${key}"
  cd ${current_directory}
done
