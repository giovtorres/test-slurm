echo "[+] Cleaning..."
rm -f slurm.{c,o,so}
echo "[+] Cythonizing slurm.pyx..."
cython slurm.pyx
if [ "$?" -eq 0 ]; then
    echo "[+] Building object file..."
    gcc -c slurm.c $(python-config --cflags) -fPIC
    echo "[+] Compiling shared object file..."
    gcc slurm.o -o slurm.so -shared $(python-config --ldflags) ${LDFLAGS}
    echo "[+] Copying slurm.so..."
    cp slurm.so ${HOME}/local/slurm
    echo "[+] Done."
fi
