#!/bin/sh

# copy compiled algorithm into base dir
cp build/mypmmoda-*.js pyDAMPF/EXECUTE_pyDAMPF/pyDAMPF_BASE/nrun/build/
cp build/mypmmoda-*.wasm pyDAMPF/EXECUTE_pyDAMPF/pyDAMPF_BASE/nrun/build/
cp build/mypmmoda-*.js pyDAMPF/EXECUTE_pyDAMPF/pyDAMPF_BASE/nrun/nruna/build/
cp build/mypmmoda-*.wasm pyDAMPF/EXECUTE_pyDAMPF/pyDAMPF_BASE/nrun/nruna/build/

# make driver.py mypyDAMPF.py module and configure motivus
cp driver.py pyDAMPF/EXECUTE_pyDAMPF/pyDAMPF_BASE/nrun/mypyDAMPF.py
cp driver.py pyDAMPF/EXECUTE_pyDAMPF/pyDAMPF_BASE/nrun/runa/mypyDAMPF.py
cp .env pyDAMPF/EXECUTE_pyDAMPF/pyDAMPF_BASE/nrun/
cp .env pyDAMPF/EXECUTE_pyDAMPF/pyDAMPF_BASE/nrun/runa/

# remove system dependant compiled binaries
rm EXECUTE_pyDAMPF/mypyDAMPF.cpython-39-x86_64-linux-gnu.so ;
rm EXECUTE_pyDAMPF/pyDAMPF_BASE/nrun/mypyDAMPF.cpython-39-x86_64-linux-gnu.so ;
rm EXECUTE_pyDAMPF/pyDAMPF_BASE/nrun/runa/mypyDAMPF.cpython-39-x86_64-linux-gnu.so ;
