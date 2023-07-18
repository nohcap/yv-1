#!/bin/bash

if [ $# -ne 3 ]; then
  echo "Usage: $0 WEBDAV_URL USERNAME PASSWORD"
  exit 1
fi

WEBDAV_URL="$1"
USERNAME="$2"
PASSWORD="$3"

LOCAL_DIR="/kaggle/working/dddd_trainer/projects/ocr1/models"

# 创建当前时间戳文件夹名称
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
REMOTE_DIR="${WEBDAV_URL}/${TIMESTAMP}"

# 使用MKCOL方法创建WebDAV远程文件夹
curl -X MKCOL -u "${USERNAME}:${PASSWORD}" "${REMOTE_DIR}"

for file in "${LOCAL_DIR}"/*; do
  if [ -f "$file" ]; then
    remote_file="${REMOTE_DIR}/$(basename "${file}")"
    curl -T "${file}" -u "${USERNAME}:${PASSWORD}" "${remote_file}"
  fi
done

# 上传ocr1.zip到WebDAV服务器的时间戳文件夹中
ocr1_zip="/kaggle/working/captcha/ocr1.zip"
remote_zip="${REMOTE_DIR}/ocr1.zip"
curl -T "${ocr1_zip}" -u "${USERNAME}:${PASSWORD}" "${remote_zip}"
