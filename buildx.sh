#!/usr/bin/env bash
set -Eeo pipefail

base_image="${base_image:-}"
version="${version:-6.2.19}";
push="${push:-false}"
repo="${repo:-dyrnq}"
image_name="${image_name:-redis-static-binaries}"
platforms="${platforms:-linux/amd64,linux/arm64/v8}"
curl_opts="${curl_opts:-}"
docker_file=${docker_file:-./Dockerfile}
while [ $# -gt 0 ]; do
    case "$1" in
        --docker-file)
            docker_file="$2"
            shift
            ;;
        --base-image|--base)
            base_image="$2"
            shift
            ;;
        --version|--ver)
            version="$2"
            shift
            ;;
        --push)
            push="$2"
            shift
            ;;
        --curl-opts)
            curl_opts="$2"
            shift
            ;;
        --platforms)
            platforms="$2"
            shift
            ;;
        --repo)
            repo="$2"
            shift
            ;;
        --image-name|--image)
            image_name="$2"
            shift
            ;;
        --*)
            echo "Illegal option $1"
            ;;
    esac
    shift $(( $# > 0 ? 1 : 0 ))
done


latest_tag=" --tag $repo/$image_name:$version"

if grep -q centos7 <<< "$version"; then
    latest_tag=" --tag $repo/$image_name:el7-$version"
fi

docker buildx build \
--platform ${platforms} \
--output "type=image,push=${push}" \
--build-arg REDIS_VERSION=${version} \
--file ${docker_file} . \
${latest_tag}



