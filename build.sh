export ARCH=arm64
export SUBARCH=arm64
export TARGET_PRODUCT=fuxi

git submodule init && git submodule update

MAKE_PARAMS="LLVM=1 LLVM_IAS=1 O=out"
make $MAKE_PARAMS fuxi_defconfig -j$(nproc --all)
make $MAKE_PARAMS Image dtbo.img -j$(nproc --all)

if [ $? -ne 0 ]
then
    exit 1
fi

rm -r out/AnyKernel3
cp -r AnyKernel3 out/

cp out/arch/arm64/boot/Image out/AnyKernel3/Image
cp out/arch/arm64/boot/dtb out/AnyKernel3/dtb
cp out/arch/arm64/boot/dtbo.img out/AnyKernel3/dtbo.img
cd out/AnyKernel3
zip -r9 fuxi-$(/bin/date -u '+%Y%m%d-%H%M').zip .
