mkdir src_llvm_clang
cd src_llvm_clang
# svn co http://llvm.org/svn/llvm-project/llvm/trunk llvm
git clone https://github.com/llvm-mirror/llvm
cd llvm/tools
# svn co http://llvm.org/svn/llvm-project/cfe/trunk clang
git clone https://github.com/llvm-mirror/clang
cd src_llvm_clang/llvm/projects
# svn co http://llvm.org/svn/llvm-project/compiler-rt/trunk compiler-rt
git clone https://github.com/llvm-mirror/compiler-rt
cd src_llvm_clang
mkdir build
cd build
cmake -G "Unix Makefiles" ../llvm
make